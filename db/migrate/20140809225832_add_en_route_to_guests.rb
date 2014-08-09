class AddEnRouteToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :en_route, :boolean
  end
end
