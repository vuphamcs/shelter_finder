class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w\.]+@[\w\.]+\z/, message: 'has to be a valid e-mail address' }
  validates :address, presence: true
  validates :phone, presence: true
  validates :size, presence: true

  def current_interest_level
    guest_interest_size = Guest.on_route_to_shelter(self.id).count.to_f

    if guest_interest_size > 0
      (guest_interest_size / size) * 100
    else
      0
    end
  end

  def current_interest_level_message
    if current_interest_level < 80
      "Current Interest Level is below 80%; this shelter is probably a safe bet!"
    elsif current_interest_level > 80 && current_interest_level < 100
      "Interest level is approaching the occupancy limit; choose this shelter with caution!"
    else
      "More people have stated that they have interest in this shelter than there are spots available; probably not a safe bet!"
    end
  end

  def notify_guests_of_full_occupancy
    account_sid = 'AC9807796dfa13060ccb409a4c04b49f0b'
    auth_token = '76ba18f96eb764435e1d4922b91cf6e8'

    @client = Twilio::REST::Client.new account_sid, auth_token

    guests = Guest.where(en_route_shelter_id: self.id)

    guests.each do |guest|
      @client.account.messages.create(
        :from => '+18572632905',
        :to => guest.phone_number,
        :body => "We've reached full occupancy!\nAlternative(s):\n#{User.print_out_shelter_list(guest)}"
      )
      guest.update_attributes!(en_route_shelter_id: nil)
    end
  end

  def self.google_distances(origin_address, addresses)
    conn = Faraday.new(:url => 'http://maps.googleapis.com') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get '/maps/api/distancematrix/json', origins: origin_address, destinations: addresses.join('|'), mode: 'walking'
    results = JSON.parse(response.body)
    results["rows"].first["elements"].map { |s| s["distance"] }
  end

  def self.google_directions(origin, destination, mode = 'transit')
    conn = Faraday.new(:url => 'http://maps.googleapis.com') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get "/maps/api/directions/json?origin=#{URI.encode(origin)}&destination=#{URI.encode(destination)}"
    directions = JSON.parse(response.body)

    copyright = directions['routes'].first['copyrights']

    include ActionView::Helpers::SanitizeHelper

    result = strip_tags(directions['routes'].first['legs'].map { |d| d['steps'] }.flatten.map { |d| d['html_instructions']}.join("\n"))
    result << copyright << "\n"
    result << "This information is highly experimental. Be careful!"
  end

  def radial_occupancy_progress
    Guest.on_route_to_shelter(self.id).count
  end

  def self.sorted_shelters(guest_address)
    shelters = ::User.where(full: false).all

    require 'ranker'

    if guest_address
      distances = ::User.google_distances(guest_address, shelters.map(&:address))
      shelters_with_scores = shelters.each_with_index.map { |shelter, i| [[shelter, distances[i]], Ranker.score(0, shelter.current_interest_level / 100, distances[i]['value'].to_i)] }
    else
      shelters_with_scores = shelters.each_with_index.map { |shelter, i| [[shelter, nil], Ranker.score(0, shelter.current_interest_level / 100, 0)] }
    end

    shelters_with_scores.sort_by(&:second).map(&:first)
  end

  def self.print_out_shelter_list(guest = nil, num = 3) #use better scope than 'num' later on
    message = ""

    sorted_shelters = ::User.sorted_shelters(guest.try(:address)).last(num).reverse

    message << "List of nearby available shelters:\n"

    sorted_shelters.each do |pair|
      u = pair.first
      distance = pair.second

      message << "#{u.name}\n"
      message << "Distance: #{distance['text']} " unless distance.nil?
      message << "ID: #{u.id}\n"
    end

    message
  end
end
