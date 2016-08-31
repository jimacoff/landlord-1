class AddStatusToLandlordAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :status, :string
  end
end
