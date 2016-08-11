class RemoveIsOwnerFromMemberships < ActiveRecord::Migration[5.0]
  def change
    remove_column :landlord_memberships, :is_owner
  end
end
