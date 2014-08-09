require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def messaging
    response = Twilio::TwiML::Response.new do |r|
      r.Message "Replying to the message you sent me"
    end

    render_twiml response
  end
end
