class AddStatusToLandlordAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :landlord_accounts, :status, :string
  end
end
