module Landlord
  class Account < ApplicationRecord
    has_many :users
    has_many :memberships, inverse_of: :account
    has_many :users, through: :memberships

    accepts_nested_attributes_for :memberships

    validates :name, presence: true
  end
end
