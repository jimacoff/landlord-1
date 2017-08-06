module Landlord
  class Plan < ApplicationRecord
    self.table_name = 'plans'

    has_many :accounts

    validates :stripe_id, presence: true, uniqueness: { case_sensitive: false }
    validates :amount, presence: true
    validates :currency, presence: true
    validates :interval, presence: true
    validates :name, presence: true

    # Create/update from a Stripe::Plan
    def self.from_stripe(stripe_plan)
      plan = Landlord::Plan.find_or_initialize_by(stripe_id: stripe_plan.id)
      plan.update!(
        amount: stripe_plan.amount,
        currency: stripe_plan.currency,
        interval: stripe_plan.interval,
        interval_count: stripe_plan.interval_count,
        name: stripe_plan.name,
        statement_descriptor: stripe_plan.statement_descriptor,
        trial_period_days: stripe_plan.trial_period_days
      )
      plan
    end

  end
end
