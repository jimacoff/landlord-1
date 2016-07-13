module Landlord
  class Account < ApplicationRecord
    belongs_to :plan
    has_many :users
    has_many :memberships, inverse_of: :account
    has_many :users, through: :memberships

    accepts_nested_attributes_for :memberships

    validates :name, presence: true
    validates :plan, presence: true

    before_validation :init_owner, only: :create

    def owner
      self.memberships.find_by(is_owner: true).user
    end

    private

      def init_owner
        if self.memberships.any?
          member = self.memberships.first
          if member
            # Don't create a user if one already exists with this email
            existing_user = User.find_by(email: member.user.email)
            if existing_user
              member.user = existing_user
            end
            member.is_owner = true
          end
        end
      end
  end
end
