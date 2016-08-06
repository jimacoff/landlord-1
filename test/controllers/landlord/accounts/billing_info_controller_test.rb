require 'test_helper'

module Landlord
  class Accounts::BillingInfoControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get accounts_billing_info_index_url
      assert_response :success
    end

    test "should get update" do
      get accounts_billing_info_update_url
      assert_response :success
    end

  end
end
