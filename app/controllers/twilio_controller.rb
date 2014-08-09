require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def messaging

    Guest.find_or_create_by_phone_number(phone_number: params[:From], city: params[:FromCity], state: params[:FromState], zip: params[:FromZip], country: params[:FromCountry] )

    message_body = params["Body"].downcase.strip
    message = ''

    if message_body.include?('shelter')
      User.where(full: false).first(3).each do |u|
        message << "ID: #{u.id} Name: #{u.name}\n"
      end

      message << "Reply with an ID for more info"

    elsif message_body =~ /\A\d+\z/ ? true : false
      u = User.where(id: message_body.to_i).first
      message << "Name: #{u.name}, Address: #{u.address}, Phone: #{u.phone}"
    else
      message << "Send 'shelter' to list shelters"
    end

    response = Twilio::TwiML::Response.new do |r|
      r.Message message
    end

    render_twiml response
  end
end
