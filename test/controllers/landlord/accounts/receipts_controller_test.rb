require 'test_helper'

module Landlord
  class Accounts::ReceiptsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get accounts_receipts_index_url
      assert_response :success
    end

    test "should get show" do
      get accounts_receipts_show_url
      assert_response :success
    end

  end
end
