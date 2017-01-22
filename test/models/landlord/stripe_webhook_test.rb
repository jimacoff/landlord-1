require 'test_helper'

module Landlord
  class StripeWebhookTest < ActiveSupport::TestCase

    test "should not save stripe_webhook without stripe_id" do
      stripe_webhook = StripeWebhook.new
      assert_not stripe_webhook.save, "Saved the stripe_webhook without a stripe_id"
    end

    test "should save valid stripe_webhook" do
      stripe_webhook = StripeWebhook.new
      stripe_webhook.stripe_id = "stripe_id"
      assert stripe_webhook.save, "Saved the stripe_webhook"
    end

  end
end
