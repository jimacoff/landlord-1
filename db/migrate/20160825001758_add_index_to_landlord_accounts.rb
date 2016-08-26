class AddIndexToLandlordAccounts < ActiveRecord::Migration[5.0]
  def change
    add_index :landlord_accounts, :status
  end
end
