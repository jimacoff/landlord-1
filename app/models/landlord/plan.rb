module Landlord
  class Plan < ApplicationRecord
    has_many :accounts
  end
end
