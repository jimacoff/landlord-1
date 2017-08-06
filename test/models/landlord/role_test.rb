require 'test_helper'

module Landlord
  class RoleTest < ActiveSupport::TestCase

    test "should not save plan without key" do
      role = Landlord::Role.new
      assert_not role.save, "Saved the plan without key"
    end

    test "should not save plan without name" do
      role = Landlord::Role.new
      role.key = 'role1'
      assert_not role.save, "Saved the plan without name"
    end

    test "should prevent duplicate keys" do
      role1 = Landlord::Role.new(
        key: 'role_key_1',
        name: 'Role 1'
      )
      assert role1.save

      role2 = Landlord::Role.new(
        key: role1.key,
        name: role1.name
      )
      assert_not role2.save, "Saved the role with duplicate key"

      role2.key = 'role_key_2'
      assert role2.save, "Saved the role with unique key"
    end

    test "should save plan when valid" do
      role = Landlord::Role.new
      role.key = 'role1'
      role.name = 'Role 1'
      assert role.save, "Saved the plan with valid attributes"
    end

  end
end
