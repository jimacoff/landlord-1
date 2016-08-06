module Landlord
  class BillingInfo < ApplicationRecord
    belongs_to :account
  end
end
