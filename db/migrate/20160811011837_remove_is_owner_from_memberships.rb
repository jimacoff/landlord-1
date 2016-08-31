class RemoveIsOwnerFromMemberships < ActiveRecord::Migration[5.0]
  def change
    remove_column :memberships, :is_owner
  end
end
