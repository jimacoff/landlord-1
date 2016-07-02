class CreateLandlordAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :landlord_accounts do |t|
      t.string :name

      t.timestamps
    end
  end
end
