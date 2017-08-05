module Landlord
  class StripePlanFetcher

    # Fetch plans from Stripe account and store them locally
    def self.fetch_all
      fetch_plans.each { |stripe_plan| create_or_update_plan(stripe_plan) }
    end

    private

      # Fetch all plans from Stripe account
      def self.fetch_plans
        begin
          stripe_plans = Stripe::Plan.list
        rescue => ex
          abort("Error retrieving plans from Stripe: #{ex.message}")
        end

        stripe_plans
      end

      # Insert/update Stripe plan locally
      def self.create_or_update_plan(stripe_plan)
        begin
          plan = Landlord::Plan.from_stripe(stripe_plan)
          puts("Imported plan: #{plan.stripe_id} (#{plan.amount} #{plan.currency})")
        rescue => ex
          puts("Error saving plan locally: #{ex.message}")
        end
      end

  end
end
