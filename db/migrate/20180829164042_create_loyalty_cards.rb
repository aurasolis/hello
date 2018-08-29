class CreateLoyaltyCards < ActiveRecord::Migration[5.1]
  def change
    create_table :loyalty_cards do |t|
      t.integer :loyalty_number
      t.integer :password
      t.integer :point_total
      t.integer :user_id

      t.timestamps
    end
  end
end
