module Landlord
  class Account < ApplicationRecord
    self.table_name = 'accounts'
    
    belongs_to :plan
    has_many :users
    has_many :memberships, inverse_of: :account
    has_many :users, through: :memberships
    has_many :receipts
    has_one :billing_info

    accepts_nested_attributes_for :memberships

    validates :name, presence: true
    validates :plan, presence: true
    validates :stripe_id, presence: true, uniqueness: true
    validates :status, presence: true

    scope :active, -> { where("status != 'canceled' AND status != 'past_due' AND status != 'unpaid'") }
    scope :not_canceled, -> { where.not(status: 'canceled') }

    before_validation :init_owner, only: :create
    before_validation :init_stripe_attributes, only: :create
    after_save :update_stripe_attributes, only: :update

    has_settings do |s|
      s.key :billing, defaults: { address: nil, cc_emails: nil }
    end

    # Return the user who is the account owner
    def owner
      membership = self.memberships.find_by(role: Landlord::Role.owner)
      raise "account has no user assigned as owner" unless membership
      membership.user
    end

    # Use billing status to determine if account is active
    def active?
      self.status != 'past_due' && self.status != 'unpaid' && self.status != 'canceled'
    end

    # Does the account require billing action?
    def billing_error?
      self.status == 'past_due' || self.status == 'unpaid'
    end

    def cancel
      raise "account has no billing ID" unless self.stripe_id

      customer = Stripe::Customer.retrieve(self.stripe_id)
      subscription = customer.subscriptions.first.delete

      self.status = subscription.status
      self.save
    end

    # Update the account's Stipe customer object
    def update_stripe_attributes
      raise "account has no billing ID" unless self.stripe_id

      customer = Stripe::Customer.retrieve(self.stripe_id)
      subscription = customer.subscriptions.first

      customer.email = self.owner.email
      customer.description = self.name
      customer.save

      subscription.plan = plan.stripe_id
      subscription.save
    end

    # Update an account's credit card for billing
    def update_stripe_card(stripe_params)
      raise "account has no billing ID" unless self.stripe_id
      raise "payment token not provided" unless stripe_params[:token]

      customer = Stripe::Customer.retrieve(self.stripe_id)
      subscription = customer.subscriptions.first

      customer.source = stripe_params[:token]
      customer.save

      self.update(
        status: subscription.status,
        card_name: stripe_params[:card_name],
        card_brand: stripe_params[:card_brand],
        card_last4: stripe_params[:card_last4],
        card_exp_month: stripe_params[:card_exp_month],
        card_exp_year: stripe_params[:card_exp_year]
      )
    end

    # Update an account's credit card from a Stripe credit card object
    def update_card_from_stripe(card)
      self.card_name = card.name
      self.card_brand = card.brand
      self.card_last4 = card.last4
      self.card_exp_month = card.exp_month
      self.card_exp_year = card.exp_year

      if self.changed?
        self.save
      end
    end

    # Update an account's settings
    def update_settings(account_params)
      account_update_params = account_params.except(:owner_id, :billing_address, :billing_cc_emails)

      settings(:billing).address = account_params[:billing_address]
      settings(:billing).cc_emails = account_params[:billing_cc_emails]

      new_owner_id = account_params[:owner_id]
      current_owner_id = self.owner.id.to_s
      change_owner = new_owner_id && new_owner_id != current_owner_id

      if change_owner
        new_owner_membership = self.memberships.find_by(user_id: new_owner_id)
        current_owner_membership = self.memberships.find_by(user_id: current_owner_id)

        if new_owner_membership
          new_owner_membership.role = Landlord::Role.owner
          new_owner_membership.save

          current_owner_membership.role = Landlord::Role.admin
          current_owner_membership.save

          self.update_stripe_attributes
        else
          errors.add(:base, "No membership found for new account owner.")
        end
      end

      self.update(account_update_params)
    end



    # Stripe webhook events (see /config/initializers/stripe.rb)

    # Customer record has been updated in Stripe
    def self.update_from_stripe_customer_event(event)
      customer = event.data.object
      card = customer.sources.retrieve(customer.default_source)
      account = Account.find_by(stripe_id: customer.id)

      raise "Event #{event.id}: customer contains Account that does not exist" unless account
      account.update_card_from_stripe(card)
    end

    # Customer credit card has been updated in Stripe
    def self.update_from_stripe_card_event(event)
      card = event.data.object
      customer = Stripe::Customer.retrieve(card.customer)
      account = Account.find_by(stripe_id: customer.id)

      if (customer.default_source == card.id)
        raise "Event #{event.id}: customer.card contains Account that does not exist" unless account
        account.update_card_from_stripe(card)
      end
    end

    # Customer subscription has been updated in Stripe
    def self.update_from_stripe_subscription_event(event)
      subscription = event.data.object
      customer = Stripe::Customer.retrieve(subscription.customer)
      account = Account.find_by(stripe_id: subscription.customer)

      raise "Event #{event.id}: customer.subscription contains Account that does not exist" unless account
      raise "Event #{event.id}: customer has multiple subscriptions" if customer.subscriptions.count > 1

      # Update the account status if it has changed in Stripe
      old_status = account.status
      new_status = subscription.status
      if old_status != new_status
        account.status = new_status
        AccountMailer.past_due(account).deliver_later if new_status == 'past_due'
      end

      # Update the account plan if it has changed in Stripe
      old_plan = account.plan
      new_plan = Plan.find_by(stripe_id: subscription.plan.id)
      raise "Event #{event.id}: customer.subscription contains Plan that does not exist" unless new_plan
      account.plan = new_plan unless old_plan == new_plan

      # Save account if any changes have been detected from Stripe
      account.save if account.changed?
    end

    private

      # Initialize the account owner user and membership relationship
      def init_owner
        if self.memberships.any?
          member = self.memberships.first
          member.role = Landlord::Role.owner
          existing_user = User.find_by(email: member.user.email)

          if existing_user
            # User already exists; use the existing record
            member.user = existing_user
          else
            # New user will receive a welcome email; skip the confirmation email
            member.user.skip_confirmation_notification!
          end
        end
      end

      # Create a Stripe customer for the account
      def init_stripe_attributes
        if self.memberships.any? && self.memberships.first.valid?
          owner_user = self.memberships.first.user
          if !self.stripe_id
            customer = Stripe::Customer.create(email: owner_user.email, plan: plan.stripe_id, description: name)
            subscription = customer.subscriptions.first
            self.stripe_id = customer.id
            self.status = subscription.status
          end
        end
      end

  end
end
