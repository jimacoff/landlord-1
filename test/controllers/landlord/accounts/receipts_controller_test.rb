require 'test_helper'

module Landlord
  class Accounts::ReceiptsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Devise::Test::IntegrationHelpers

    test "should only allow owner access" do
      owner_mem = landlord_memberships(:owner_1)
      admin_mem = landlord_memberships(:admin_1)

      sign_in owner_mem.user
      get account_receipts_url(owner_mem.account)
      assert_response :success

      sign_in admin_mem.user
      get account_receipts_url(admin_mem.account)
      assert_response :redirect
    end

  end
end
