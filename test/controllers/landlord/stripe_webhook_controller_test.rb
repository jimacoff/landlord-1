require 'test_helper'

module Landlord
  class StripeWebhookControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should post stripe webhook event" do
      skip("TODO: Setup fake_stripe gem for Stripe method testing")
    end

  end
end
