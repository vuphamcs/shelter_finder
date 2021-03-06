require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def messaging
    guest = Guest.create_with(city: params[:FromCity], state: params[:FromState], zip: params[:FromZip], country: params[:FromCountry]).find_or_create_by(phone_number: params[:From])

    message_body = params["Body"].downcase.strip
    message = ''

    if message_body.starts_with?('hi')
      message << "Hello!\n"
    end

    if message_body.starts_with?('thank')
      message << "You are important, we love to make your life easier."
    elsif message_body.starts_with?('battlehack')
      message << "Hack on brother/sister!"
    elsif message_body.starts_with?('whatever')
      message << "Indifference is the path to jealousy. Jealousy is the path to hate. Hate is the path to the dark side."
    elsif message_body.starts_with?('kudos')
      message << "http://isitbeertimefor.us"
    elsif message_body.starts_with?('address')
      guest.address = message_body[7..-1]
      guest.save!
      message << User.print_out_shelter_list(guest)

    elsif message_body.include?('shelters')
      message << User.print_out_shelter_list(guest)
    elsif message_body =~ /\A\d+\z/ ? true : false
      u = nil
      if User.all.map(&:id).include?(message_body.to_i)
        u = User.where(id: message_body.to_i).first
        guest.update_attributes!(possible_shelter_id: u.id)

        message << "Name: #{u.name}, Address: #{u.address}, Phone: #{u.phone} \n" if u
        message << "Are you heading over?\n (reply 'yes' or 'no')"

      else
        message << "Please enter an ID from the Shelter list:  \n \n"
        message << User.print_out_shelter_list(guest)
      end

    elsif message_body.include?('yes' || 'no')
      if message_body.length <= 3
        if message_body.include?('yes')
          guest.update_attributes!(en_route: true, en_route_shelter_id: guest.possible_shelter_id)

          message << "Great! We'll notify you if we've reached full occupancy prior to your arrival! Send 'directions' for experimental directions."
        else

          message << "Ok! Let us know if you change your mind! \n"
          message << User.print_out_shelter_list(guest)
        end
      end

    elsif message_body.starts_with?('directions')
      if guest.address && guest.en_route_shelter
        message << User.google_directions(guest.address, guest.en_route_shelter.address)
      else
        message << "Please specify a current address and an intent."
      end
    else
      if guest.address
        message << "Send 'address' followed by your current address to change your current address.\nYour current address is #{guest.address}. Send 'shelters' to get a list of available shelters near you."
      else
        message << "Send 'address' followed by your current address to find shelters near you\ne.g. address 12 Coral Street, Boston MA, 02121. Send 'shelters' to get a list of available shelters."
      end
      message << "\nYour current intent is #{guest.en_route_shelter.name}." if guest.en_route_shelter
    end

    response = Twilio::TwiML::Response.new do |r|
      r.Message message
    end

    render_twiml response
  end
end
