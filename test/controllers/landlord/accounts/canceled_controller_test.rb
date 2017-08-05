require 'test_helper'

module Landlord
  class Accounts::CanceledControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get accounts_canceled_index_url
      assert_response :success
    end

  end
end
