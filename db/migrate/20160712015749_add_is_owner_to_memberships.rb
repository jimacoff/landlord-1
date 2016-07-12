class AddIsOwnerToMemberships < ActiveRecord::Migration[5.0]
  def change
    add_column :landlord_memberships, :is_owner, :boolean
  end
end
