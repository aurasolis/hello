class AddNipAndFavSeatAndAvailableKmsAndTripsAndCustomerTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nip, :integer
    add_column :users, :fav_seat, :integer
    add_column :users, :available_kms, :integer
    add_column :users, :customer_type, :string
  end
end
