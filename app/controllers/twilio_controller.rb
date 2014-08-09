require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def messaging
    response = Twilio::TwiML::Response.new do |r|
      Users.where(full: false).first(3).each do |u|
        message << "#{u.name}, #{u.address}, #{u.phone}\n"
      end

      r.Message message
    end

    render_twiml response
  end
end
