class CreateLandlordMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.integer :account_id, foreign_key: true, null: false
      t.integer :user_id, foreign_key: true, null: false

      t.timestamps
    end
  end
end
