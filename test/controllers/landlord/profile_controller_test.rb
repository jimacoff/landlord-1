require 'test_helper'

module Landlord
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get edit" do
      get profile_edit_url
      assert_response :success
    end

    test "should get update" do
      get profile_update_url
      assert_response :success
    end

  end
end
