class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :phone_number
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
    end
  end
end
