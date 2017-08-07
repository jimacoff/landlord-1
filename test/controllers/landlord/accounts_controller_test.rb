require 'test_helper'

module Landlord
  class AccountsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Devise::Test::IntegrationHelpers

    test "should display new account route" do
      get new_account_url
      assert_response :success
    end

    test "should not display account list route unless authenticated" do
      get accounts_url
      assert_response :redirect

      sign_in landlord_users(:one)
      get accounts_url
      assert_response :success
    end

    test "should only allow user access with valid membership" do
      m1 = landlord_memberships(:owner_1)
      m2 = landlord_memberships(:owner_2)

      sign_in m1.user
      get account_url(m1.account)
      assert_response :success

      get account_url(m2.account)
      assert_response :redirect
    end
  end
end
