class AddIndexToLandlordMemberships < ActiveRecord::Migration[5.0]
  def change
    add_index :landlord_memberships, [:account_id, :user_id], unique: true
    add_index :landlord_memberships, :role
  end
end
