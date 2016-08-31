module Landlord
  class Receipt < ApplicationRecord
    self.table_name = 'receipts'

    belongs_to :account

    validates :stripe_id, presence: true, uniqueness: true
    validates :account, presence: true

    # Creates or updates a Receipt from a Stripe charge object
    def self.save_from_stripe(charge)
      account = Account.find_by(stripe_id: charge.customer)
      if (account)
        receipt = account.receipts.find_or_initialize_by(stripe_id: charge.id)
        receipt.charged_at = Time.at(charge.created)
        receipt.status = charge.status
        receipt.paid = charge.paid
        receipt.captured = charge.captured
        receipt.refunded = charge.refunded
        receipt.amount = charge.amount
        receipt.amount_refunded = charge.amount_refunded
        receipt.currency = charge.currency
        receipt.description = charge.description
        receipt.card_brand = charge.source.brand
        receipt.card_last4 = charge.source.last4
        receipt.failure_message = charge.failure_message
        receipt.failure_code = charge.failure_code
        receipt.save
        receipt
      else
        nil
      end
    end
  end
end
