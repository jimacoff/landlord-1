module Landlord
  class Account < ApplicationRecord
    validates :name, presence: true
  end
end
