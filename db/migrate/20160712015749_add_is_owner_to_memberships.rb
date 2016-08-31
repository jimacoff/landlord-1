class AddIsOwnerToMemberships < ActiveRecord::Migration[5.0]
  def change
    add_column :memberships, :is_owner, :boolean
  end
end
