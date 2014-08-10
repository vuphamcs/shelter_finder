class FixSomeTypes < ActiveRecord::Migration
  def change
    remove_column :guests, :possible_shelter_id
    add_column :guests, :possible_shelter_id, :integer
    add_index :guests, :possible_shelter_id
    add_index :guests, :en_route_shelter_id
  end
end
