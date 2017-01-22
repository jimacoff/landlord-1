require 'test_helper'

module Landlord
  class MembershipTest < ActiveSupport::TestCase

    test "should not save membership without account" do
      membership = Membership.new
      assert_not membership.save, "Saved the membership without an account"
    end

    test "should not save membership without user" do
      membership = Membership.new
      membership.account = Account.first
      assert_not membership.save, "Saved the membership without a user"
    end

    test "should save valid membership" do
      membership = Membership.new
      membership.account = Account.first
      membership.user = User.first
      assert membership.save, "Saved the membership"
    end

  end
end
