# frozen_string_literal: true

module MailersendRails
  class Mailer
    def initialize(config)
      puts "MailersendRails config: #{config}"
    end

    # Sends the email and returns result
    def deliver(msg)
      ms_msg = msg_to_ms_msg(msg)
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

    # Transforms Rails email message to Mailersend::Email
    def msg_to_ms_msg(msg)
      ms_msg = Mailersend::Email.new
      ms_msg.add_subject(msg.subject)
      ms_msg.recipients = msg.to
      ms_msg.add_from = msg.from[0]
      ms_msg.add_html(msg_html(msg))
      ms_msg.add_text(msg_text(msg))
      ms_msg.ccs = msg.cc
      ms_msg.bcc = msg.bcc
      ms_msg
    end

    # Get plaintext from Rails email msg
    def msg_text(msg)
      if msg.multipart?
        return msg.text.part
      end

      if msg.mime_type ~= /^text\/plain$/i
        return msg
      end

      nil
    rescue
      nil
    end

    # Get html from Rails email msg
    def msg_html(msg)
      if msg.multipart?
        return msg.html.part
      end

      if msg.mime_type ~= /^text\/html$/i
        return msg
      end

      nil
    rescue
      nil
    end
  end
end
