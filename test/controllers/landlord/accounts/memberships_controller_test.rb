require 'test_helper'

module Landlord
  class Accounts::MembershipsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get accounts_memberships_index_url
      assert_response :success
    end

    test "should get create" do
      get accounts_memberships_create_url
      assert_response :success
    end

    test "should get edit" do
      get accounts_memberships_edit_url
      assert_response :success
    end

    test "should get update" do
      get accounts_memberships_update_url
      assert_response :success
    end

    test "should get destroy" do
      get accounts_memberships_destroy_url
      assert_response :success
    end

  end
end
