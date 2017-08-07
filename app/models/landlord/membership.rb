module Landlord
  class Membership < ApplicationRecord
    self.table_name = 'memberships'

    belongs_to :account
    belongs_to :user
    belongs_to :role

    accepts_nested_attributes_for :user

    validates :account, presence: true
    validates :user, presence: true, uniqueness: { scope: :account, message: 'already belongs to Account' }
    validates :role, presence: true

    # .owner?, .admin?, etc
    Landlord::Role.keys.each_with_index do |method_name, index|
      define_method("#{method_name}?") { self.role == Landlord::Role.send("#{method_name}") }
    end

    def self.add_memberships(email_addresses, role_id, account_id)
      memberships = []

      role = Landlord::Role.find(role_id)
      raise 'invalid role' if !role

      account = Landlord::Account.find(account_id)
      raise 'invalid account' if !account

      email_addresses.each do |email|
        invite_sent = false

        # Find the user, or send an invite email
        user = User.find_by(email: email)
        if !user
          user = User.invite!(email: email)
          invite_sent = true
        end

        # Add the user-account membership if it does not exist
        membership = user.memberships.find_by(account: account)
        if !membership
          membership = user.memberships.create(account: account, role: role)
          memberships << membership
          AccountMailer.invite(membership).deliver_later unless invite_sent
        end
      end

      # Return all memberships that were added
      memberships
    end

  end
end
