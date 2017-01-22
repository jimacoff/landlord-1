require 'test_helper'

module Landlord
  class AccountTest < ActiveSupport::TestCase

    test "should not save account without name" do
      account = Account.new
      assert_not account.save, "Saved the account without a name"
    end

    test "should not save account without plan" do
      account = Account.new
      account.name = "Account"
      assert_not account.save, "Saved the account without a plan"
    end

    test "should not save account without stripe_id" do
      account = Account.new
      account.name = "Account"
      account.plan = Plan.first
      assert_not account.save, "Saved the account without a stripe_id"
    end

    test "should not save account without status" do
      account = Account.new
      account.name = "Account"
      account.plan = Plan.first
      account.stripe_id = "stripe_id"
      assert_not account.save, "Saved the account without a status"
    end

    test "should save valid account" do
      account = Account.new
      account.name = "Account"
      account.plan = Plan.first
      account.stripe_id = "stripe_id"
      account.status = "trialing"
      account.memberships.new(user: User.first)
      skip("TODO: Setup fake_stripe gem for Stripe method testing")
    end
  end
end
