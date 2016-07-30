module Landlord
  class StripeWebhook < ApplicationRecord
    validates :stripe_id, presence: true, uniqueness: true
  end
end
