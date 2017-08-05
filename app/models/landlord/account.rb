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
      s.key :billing, :defaults => { :address => nil, :cc_emails => nil }
    end



    # Return the user who is the account owner
    def owner
      self.memberships.find_by(role: "owner").user
    end

    # Return boolean indicating if account is currently active, based on billing status
    def active?
      self.status != 'past_due' && self.status != 'unpaid' && self.status != 'canceled'
    end

    def billing_error?
      self.status == 'past_due' || self.status == 'unpaid'
    end

    def cancel
      if self.stripe_id
        customer = Stripe::Customer.retrieve(self.stripe_id)
        subscription = customer.subscriptions.first.delete
        self.status = subscription.status
        self.save
      end
    end

    # Update the account's Stipe customer object
    def update_stripe_attributes
      if self.stripe_id && self.owner
        customer = Stripe::Customer.retrieve(self.stripe_id)
        subscription = customer.subscriptions.first

        customer.email = self.owner.email
        customer.description = self.name
        customer.save

        subscription.plan = self.plan.stripe_id
        subscription.save
      end
    end

    def update_stripe_card(stripe_params)
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



    # Stripe webhook events (see /config/initializers/stripe.rb)

    # Customer record has been updated in Stripe
    def self.update_from_stripe_customer_event(event)
      customer = event.data.object
      card = customer.sources.retrieve(customer.default_source)
      account = Account.find_by(stripe_id: customer.id)

      if !account
        SupportMailer.notification('Stripe event error', 'customer contains Account that does not exist: ' + event.id).deliver_later
      else
        account.update_card_from_stripe(card)
      end
    end

    # Customer credit card has been updated in Stripe
    def self.update_from_stripe_card_event(event)
      card = event.data.object
      customer = Stripe::Customer.retrieve(card.customer)
      account = Account.find_by(stripe_id: customer.id)

      if (customer.default_source == card.id)
        if !account
          SupportMailer.notification('Stripe event error', 'customer.card contains Account that does not exist: ' + event.id).deliver_later
        else
          account.update_card_from_stripe(card)
        end
      end
    end

    # Customer subscription has been updated in Stripe
    def self.update_from_stripe_subscription_event(event)
      subscription = event.data.object
      customer = Stripe::Customer.retrieve(subscription.customer)
      account = Account.find_by(stripe_id: subscription.customer)

      if !account
        SupportMailer.notification('Stripe event error', 'customer.subscription contains Account that does not exist: ' + event.id).deliver_later
      end
      if customer.subscriptions.count > 1
        SupportMailer.notification('Stripe event error', 'customer has multiple subscriptions: ' + event.id).deliver_later
      end

      if account

        # Update the account status if it has changed in Stripe
        old_status = account.status
        new_status = subscription.status
        if old_status != new_status
          account.status = new_status
        end

        # Update the account plan if it has changed in Stripe
        new_plan = Plan.find_by(stripe_id: subscription.plan.id)
        if !new_plan
          SupportMailer.notification('Stripe event error', 'customer.subscription contains Plan that does not exist: ' + event.id).deliver_later
        else
          if account.plan != new_plan
            account.plan = new_plan
          end
        end
        
        # Save account if any changes have been detected from Stripe
        if account.changed?
          account.save

          if new_status == 'past_due' && old_status != new_status
            AccountMailer.past_due(account).deliver_later
          end

        end
      end
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



    private

      # Initialize the account owner user and membership relationship
      def init_owner
        if self.memberships.any?
          member = self.memberships.first
          if member
            existing_user = User.find_by(email: member.user.email)
            if existing_user
              # User already exists; use the existing record
              member.user = existing_user
            else
              # New user will receive a welcome email; skip the confirmation email
              member.user.skip_confirmation_notification!
            end
            member.role = "owner"
          end
        end
      end

      # Create a Stripe customer for the account
      def init_stripe_attributes
        if self.memberships.any? && self.memberships.first.valid?
          owner_user = self.memberships.first.user
          if !self.stripe_id
            customer = Stripe::Customer.create(email: owner_user.email, plan: self.plan.stripe_id, description: self.name)
            subscription = customer.subscriptions.first
            self.stripe_id = customer.id
            self.status = subscription.status
          end
        end
      end

  end
end
