class RemoveRoleFromMemberships < ActiveRecord::Migration[5.0]
  def change
    remove_column :memberships, :role, :integer
  end
end
