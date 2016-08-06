require 'test_helper'

module Landlord
  class StripeWebhookControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get event" do
      get stripe_webhook_event_url
      assert_response :success
    end

  end
end
