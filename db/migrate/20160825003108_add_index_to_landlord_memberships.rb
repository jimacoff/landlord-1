class AddIndexToLandlordMemberships < ActiveRecord::Migration[5.0]
  def change
    add_index :memberships, [:account_id, :user_id], unique: true
    add_index :memberships, :role
  end
end
