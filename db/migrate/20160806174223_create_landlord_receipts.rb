class CreateLandlordReceipts < ActiveRecord::Migration[5.0]
  def change
    create_table :landlord_receipts do |t|
      t.string :stripe_id, index: true, null: false
      t.references :account, foreign_key: true, null: false
      t.integer :amount
      t.integer :amount_refunded
      t.boolean :captured
      t.string :card_brand
      t.string :card_last4
      t.datetime :charged_at
      t.string :currency
      t.string :description
      t.string :failure_message
      t.string :failure_code
      t.boolean :paid
      t.boolean :refunded
      t.string :status

      t.timestamps
    end
  end
end
