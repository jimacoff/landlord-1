class CreateLandlordRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :key
      t.string :name

      t.timestamps
    end

    add_index :roles, :key, unique: true
  end
end
