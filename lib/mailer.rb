# frozen_string_literal: true
require 'railtie'
require 'rails_msg_to_ms_msg'

module MailersendRails
  class Mailer
    def initialize(config)
      # No config yet
    end

    # Sends the email and returns result
    def deliver(msg)
      ms_msg = RailsMsgToMsMsg.msg_to_ms_msg(msg)
      ms_msg.send
    end

    # Sends the email and raises error if it occurs
    def deliver!(msg)
      result = deliver(msg)
      # Not 200 means error
      if result.code < 200 || result.code > 204
        raise "Mailersend error code #{result.code}: #{result}"
      end
      result
    end

    private
  end
end
