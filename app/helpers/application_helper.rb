require 'uri'

module ApplicationHelper
  include FoundationRailsHelper::FlashHelper

  def gmap(address)
    "http://maps.googleapis.com/maps/api/staticmap?center=#{URI.escape(address)}&zoom=15&size=300x200&maptype=roadmap&markers=color:red%7Clabel:%7C#{URI.escape(address)}"
  end

  def gmap_link(address)
    "https://www.google.com/maps/place/#{URI.escape(address)}"
  end
end
