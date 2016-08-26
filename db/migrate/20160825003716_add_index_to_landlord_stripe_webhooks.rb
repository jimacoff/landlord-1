class AddIndexToLandlordStripeWebhooks < ActiveRecord::Migration[5.0]
  def change
    add_index :landlord_stripe_webhooks, :stripe_id, unique: true
  end
end
