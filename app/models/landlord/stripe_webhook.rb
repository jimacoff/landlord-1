module Landlord
  class StripeWebhook < ApplicationRecord
    self.table_name = 'stripe_webhooks'

    validates :stripe_id, presence: true, uniqueness: true
  end
end
