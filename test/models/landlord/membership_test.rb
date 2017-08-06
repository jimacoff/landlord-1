require 'test_helper'

module Landlord
  class MembershipTest < ActiveSupport::TestCase

    test "should not save membership without account" do
      membership = Landlord::Membership.new
      assert_not membership.save, "Saved the membership without an account"
    end

    test "should not save membership without user" do
      membership = Landlord::Membership.new
      membership.account = Landlord::Account.first
      assert_not membership.save, "Saved the membership without a user"
    end

    test "should not save membership without role" do
      membership = Landlord::Membership.new
      membership.account = Landlord::Account.first
      membership.user = Landlord::User.first
      assert_not membership.save, "Saved the membership without a user"
    end

    test "should save valid membership" do
      membership = Landlord::Membership.new
      membership.account = Landlord::Account.first
      membership.user = Landlord::User.first
      membership.role = Landlord::Role.owner
      assert membership.save, "Saved the membership"
    end

  end
end
