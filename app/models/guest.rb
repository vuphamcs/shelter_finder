class Guest < ActiveRecord::Base

  def self.on_route_to_shelter(shelter_id)
    where(en_route_shelter_id: shelter_id)
  end
end
