module Landlord
  class Plan < ApplicationRecord
    self.table_name = 'plans'

    has_many :accounts
  end
end
