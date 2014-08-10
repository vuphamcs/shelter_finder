require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def messaging
    guest = Guest.create_with(city: params[:FromCity], state: params[:FromState], zip: params[:FromZip], country: params[:FromCountry], en_route: params[:FromEnRoute], possible_shelter_id: params[:FromEnRoute]).find_or_create_by(phone_number: params[:From])

    message_body = params["Body"].downcase.strip
    message = ''

    if message_body.include?('shelter')
      User.where(full: false).first(3).each do |u|
        message << "ID: #{u.id} Name: #{u.name}\n"
      end

      message << "Reply with an ID for more info"

    elsif message_body =~ /\A\d+\z/ ? true : false
      u = nil
      if User.all.map(&:id).include?(message_body.to_i)
        u = User.where(id: message_body.to_i).first
        message << "Name: #{u.name}, Address: #{u.address}, Phone: #{u.phone} \n" if u
        message << "Are you heading over?\n (reply with 'Yes' or 'No')"

      else
        message << "Please enter an ID from the Shelter list:  \n \n"
        User.where(full: false).first(3).each do |u|
          message << "ID: #{u.id} Name: #{u.name}\n"
        end
      end

      

    elsif message_body.include?('yes' || 'no')
      guest.update_attributes(en_route: true)

      message << "Great!  We've notify you if we've reached full occupancy prior to your arrival!"



    else
      message << "Send 'shelter' to list shelters"
    end

    response = Twilio::TwiML::Response.new do |r|
      r.Message message
    end

    render_twiml response
  end
end
