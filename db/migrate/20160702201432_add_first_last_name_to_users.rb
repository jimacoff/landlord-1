class AddFirstLastNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :landlord_users, :first_name, :string
    add_column :landlord_users, :last_name, :string
  end
end
