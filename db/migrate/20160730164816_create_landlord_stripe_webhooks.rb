class CreateLandlordStripeWebhooks < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_webhooks do |t|
      t.string :stripe_id, null: false

      t.timestamps
    end
  end
end
