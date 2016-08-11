class AddRoleToMemberships < ActiveRecord::Migration[5.0]
  def change
    add_column :landlord_memberships, :role, :integer, default: 0
  end
end
