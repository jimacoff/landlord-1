require 'test_helper'

module Landlord
  class AccountsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should display new account route" do
      get new_account_url
      assert_response :success
    end

    test "should not display account list route unless authenticated" do
      get accounts_url
      assert_response :redirect
    end
  end
end
