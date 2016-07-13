# desc "Explaining what the task does"
# task :landlord do
#   # Task goes here
# end
require "landlord/stripe_plan_fetcher"

namespace :landlord do
  desc "Import plans from Stripe"
  task :import_plans => :environment do
    Landlord::StripePlanFetcher.create_plans
  end
end
