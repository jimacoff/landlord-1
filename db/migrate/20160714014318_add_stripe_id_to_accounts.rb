class AddStripeIdToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :landlord_accounts, :stripe_id, :string
    add_index :landlord_accounts, :stripe_id, unique: true
  end
end
