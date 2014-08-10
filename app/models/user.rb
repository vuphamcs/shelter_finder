class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w\.]+@[\w\.]+\z/, message: 'has to be a valid e-mail address' }
  validates :address, presence: true
  validates :phone, presence: true

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


  def self.print_out_shelter_list(guest = nil, num = 3) #use better scope than 'num' later on
    message = ""

    shelters = where(full: false).all

    if guest_address = guest.try(:address)
      distances = google_distances(guest_address, shelters.map(&:address))
    else
      distances = shelters.map { |_| 0 }
    end

    # require 'ranker'

    # shelters.each_with_index.map { |shelter, i| Ranker.score(0, distances[i], shelter.) }

    shelters.each_with_index.map do |u, i|
      message << "ID: #{u.id} Name: #{u.name}\n"
      message << "Distance: #{distances[i]}" unless distances[i].blank?
    end

    message
  end
end
