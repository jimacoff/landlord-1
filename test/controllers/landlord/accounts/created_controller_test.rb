require 'test_helper'

module Landlord
  class Accounts::CreatedControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get accounts_created_index_url
      assert_response :success
    end

  end
end
