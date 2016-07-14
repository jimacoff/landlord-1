module Landlord
  class Account < ApplicationRecord
    belongs_to :plan
    has_many :users
    has_many :memberships, inverse_of: :account
    has_many :users, through: :memberships

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

    def owner
      self.memberships.find_by(is_owner: true).user
    end

    def active?
      self.status != 'past_due' && self.status != 'unpaid' && self.status != 'canceled'
    end

    private

      def init_owner
        if self.memberships.any?
          member = self.memberships.first
          if member
            # Don't create a user if one already exists with this email
            existing_user = User.find_by(email: member.user.email)
            if existing_user
              member.user = existing_user
            end
            member.is_owner = true
          end
        end
      end

      def init_stripe_attributes
        if self.memberships.any?
          owner_user = self.memberships.first.user
          if !self.stripe_id
            customer = Stripe::Customer.create(email: owner_user.email, plan: self.plan.stripe_id, description: self.name)
            subscription = customer.subscriptions.first
            self.stripe_id = customer.id
            self.status = subscription.status
          end
        end
      end

      def update_stripe_attributes
        if self.stripe_id && self.owner
          customer = Stripe::Customer.retrieve(self.stripe_id)
          customer.email = self.owner.email
          customer.description = self.name
          customer.save
        end
      end

  end
end
