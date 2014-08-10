class AddEnRouteToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :en_route, :integer
  end
end
