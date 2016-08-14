require 'test_helper'

module Landlord
  class Accounts::UsersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get update" do
      get accounts_users_update_url
      assert_response :success
    end

  end
end
