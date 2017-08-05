# desc "Explaining what the task does"
# task :landlord do
#   # Task goes here
# end
require "landlord/stripe_plan_fetcher"

namespace :landlord do
  desc "Fetch plans from Stripe"
  task :fetch_stripe_plans => :environment do
    Landlord::StripePlanFetcher.fetch_all
  end
end
