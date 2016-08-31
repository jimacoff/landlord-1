class AddIndexToLandlordAccounts < ActiveRecord::Migration[5.0]
  def change
    add_index :accounts, :status
  end
end
