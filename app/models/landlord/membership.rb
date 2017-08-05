module Landlord
  class Membership < ApplicationRecord
    self.table_name = 'memberships'

    enum role: { normal: 0, admin: 1, owner: 2, restricted: 3 }

    belongs_to :account
    belongs_to :user

    accepts_nested_attributes_for :user

    validates :account, presence: true
    validates :user, presence: true, uniqueness: { scope: :account, message: 'already belongs to Account' }

    def owner?
      self.role == "owner"
    end

    def admin?
      self.role == "admin"
    end

    def normal?
      self.role == "normal"
    end

    def restricted?
      self.role == "restricted"
    end

    def self.add_memberships(email_addresses, role_id, account_id)
      memberships = []

      email_addresses.each do |email|
        invite_sent = false

        # Find the user, or send an invite email
        user = User.find_by(email: email)
        if !user
          user = User.invite!(email: email)
          invite_sent = true
        end

        # Add the user-account membership if it does not exist
        membership = user.memberships.find_by(account_id: account_id)
        if !membership
          membership = user.memberships.create(account_id: account_id, role: role_id)
          memberships << membership
          AccountMailer.invite(membership).deliver_later unless invite_sent
        end
      end

      # Return all memberships that were added
      memberships
    end

  end
end
