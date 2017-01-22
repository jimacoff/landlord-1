require 'test_helper'

module Landlord
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should not display edit profile route unless authenticated" do
      get edit_profile_url
      assert_response :redirect
    end

  end
end
