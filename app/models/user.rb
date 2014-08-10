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
        :body => "We've reached full occupancy!\n Alternative(s): #{User.print_out_shelter_list(3)}"
      )
    end
  end


  def self.print_out_shelter_list(num) #use better scope than 'num' later on
    message = ""

    where(full: false).first(num).each do |u|
      message << "ID: #{u.id} Name: #{u.name}\n"
    end

    message
  end
end
