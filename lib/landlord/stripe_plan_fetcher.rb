module Landlord
  class StripePlanFetcher
    def self.create_plans
      Stripe::Plan.list.each do |stripe_plan|
        Landlord::Plan.create(
          stripe_id: stripe_plan.id,
          amount: stripe_plan.amount,
          currency: stripe_plan.currency,
          interval: stripe_plan.interval,
          interval_count: stripe_plan.interval_count,
          name: stripe_plan.name,
          statement_descriptor: stripe_plan.statement_descriptor,
          trial_period_days: stripe_plan.trial_period_days
        )
      end
    end
  end
end
