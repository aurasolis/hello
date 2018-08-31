class AddSpCardToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :sp_card, :string
  end
end
