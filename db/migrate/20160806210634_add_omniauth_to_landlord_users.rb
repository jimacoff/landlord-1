class AddOmniauthToLandlordUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :landlord_users, :provider, :string
    add_column :landlord_users, :uid, :string
  end
end
