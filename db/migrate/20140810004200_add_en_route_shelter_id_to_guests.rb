class AddEnRouteShelterIdToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :en_route_shelter_id, :integer
  end
end
