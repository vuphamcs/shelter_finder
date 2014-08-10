class AddAddressToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :address, :string
  end
end
