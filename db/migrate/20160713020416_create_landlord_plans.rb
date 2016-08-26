class CreateLandlordPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :landlord_plans do |t|
      t.string :stripe_id, null: false
      t.integer :amount
      t.string :currency
      t.string :interval
      t.integer :interval_count
      t.string :name
      t.string :statement_descriptor
      t.integer :trial_period_days

      t.timestamps
    end
    add_index :landlord_plans, :stripe_id, unique: true
  end
end
