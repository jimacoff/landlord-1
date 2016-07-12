module Landlord
  class Membership < ApplicationRecord
    belongs_to :account
    belongs_to :user

    accepts_nested_attributes_for :user

    validates :account, presence: true
    validates :user, presence: true, uniqueness: { scope: :account, message: 'already belongs to Account' }
    validates :is_owner, presence: true
  end
end
