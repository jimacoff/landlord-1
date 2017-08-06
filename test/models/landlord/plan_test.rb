require 'test_helper'

module Landlord
  class PlanTest < ActiveSupport::TestCase

    test "should not save plan without stripe_id" do
      plan = Landlord::Plan.new
      assert_not plan.save, "Saved the plan without stripe_id"
    end

    test "should not save plan without amount" do
      plan = Landlord::Plan.new
      plan.stripe_id = 'stripe_id_1'
      assert_not plan.save, "Saved the plan without amount"
    end

    test "should not save plan without currency" do
      plan = Landlord::Plan.new
      plan.stripe_id = 'stripe_id_1'
      plan.amount = 1000
      assert_not plan.save, "Saved the plan without currency"
    end

    test "should not save plan without interval" do
      plan = Landlord::Plan.new
      plan.stripe_id = 'stripe_id_1'
      plan.amount = 1000
      plan.currency = 'usd'
      plan.interval = 'month'
      assert_not plan.save, "Saved the plan without interval"
    end

    test "should not save plan without name" do
      plan = Landlord::Plan.new
      plan.stripe_id = 'stripe_id_1'
      plan.amount = 1000
      plan.currency = 'usd'
      plan.interval = 'month'
      assert_not plan.save, "Saved the plan without name"
    end

    test "should not save valid plan" do
      plan = Landlord::Plan.new
      plan.stripe_id = 'stripe_id_1'
      plan.amount = 1000
      plan.currency = 'usd'
      plan.interval = 'month'
      plan.name = 'Plan 1'
      assert plan.save, "Saved the plan with valid attributes"
    end

  end
end
