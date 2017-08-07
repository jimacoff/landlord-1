require 'test_helper'

module Landlord
  class Accounts::CreatedControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get account_created_url
      assert_response :success
    end

  end
end
