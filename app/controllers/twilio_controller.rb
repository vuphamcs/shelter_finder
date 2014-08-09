require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def messaging
    message_body = params["Body"].downcase.strip
    message = ''

    if message_body.include?('shelter')
      User.where(full: false).first(3).each do |u|
        message << "ID: #{u.id} Name: #{u.name}\n"
      end

      message << "Reply with an ID for more info"

    elsif message_body =~ /\A\d+\z/
      User.where(id: message_body.to_i).first.each do |u|
        message << "Name: #{u.name}, Address: #{u.address}, Phone: #{u.phone}"
      end
    else
      message << "Send 'shelter' to list shelters"
    end

    response = Twilio::TwiML::Response.new do |r|
      r.Message message
    end

    render_twiml response
  end
end
