require 'test_helper'

module Landlord
  class Accounts::BillingControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get edit" do
      get accounts_billing_edit_url
      assert_response :success
    end

    test "should get update" do
      get accounts_billing_update_url
      assert_response :success
    end

  end
end
