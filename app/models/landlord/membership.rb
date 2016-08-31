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
  end
end
