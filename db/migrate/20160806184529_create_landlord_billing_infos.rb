class CreateLandlordBillingInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :landlord_billing_infos do |t|
      t.belongs_to :account, index: true, unique: true, foreign_key: true
      t.string :address
      t.string :cc_emails

      t.timestamps
    end
  end
end
