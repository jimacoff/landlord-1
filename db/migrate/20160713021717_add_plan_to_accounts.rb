class AddPlanToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_reference :landlord_accounts, :plan, foreign_key: true
  end
end
