class AddIndexToLandlordStripeWebhooks < ActiveRecord::Migration[5.0]
  def change
    add_index :stripe_webhooks, :stripe_id, unique: true
  end
end
