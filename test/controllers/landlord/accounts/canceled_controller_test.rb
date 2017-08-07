require 'test_helper'

module Landlord
  class Accounts::CanceledControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get account_canceled_url
      assert_response :success
    end

  end
end
