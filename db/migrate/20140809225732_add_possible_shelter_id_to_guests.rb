class AddPossibleShelterIdToGuests < ActiveRecord::Migration
  def change
  	add_column :guests, :possible_shelter_id, :boolean
  end
end
