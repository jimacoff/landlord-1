class AddRoleRefToMemberships < ActiveRecord::Migration[5.0]
  def change
    add_reference :memberships, :role, foreign_key: true
  end
end
