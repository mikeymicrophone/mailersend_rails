# frozen_string_literal: true
require 'railtie'

module MailersendRails
  class Mailer
    def initialize(config)
      # No config yet
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
      ms_msg.recipients = msg.to.map { |email| {email: email, name: email}}
      ms_msg.add_from(name: msg.from_address.display_name,
                      email: msg.from_address.address)
      ms_msg.add_html(msg_html(msg))
      ms_msg.add_text(msg_text(msg))
      ms_msg.ccs = msg.cc
      ms_msg.bcc = msg.bcc

      if ms_msg.text.nil? && ms_msg.html.nil?
        Rails.logger.warn("Trying to send a message \
without plaintext and html: #{msg}")
      end
      ms_msg
    end

    # Get plaintext from Rails email msg
    def msg_text(msg)
      if msg.multipart?
        text = msg.parts
          .find { |p| p.content_type =~ /^text\/plain[;$]/ }
          &.body
          &.raw_source
        return text
      end

      if msg.mime_type =~ /^text\/plain$/i
        return msg.body.raw_source
      end

      nil
    rescue
      nil
    end

    # Get html from Rails email msg
    def msg_html(msg)
      if msg.multipart?
        html = msg.parts
          .find { |p| p.content_type =~ /^text\/html[;$]/ }
          &.body
          &.raw_source
        return html
      end

      if msg.mime_type =~ /^text\/html$/i
        return msg.body.raw_source
      end

      nil
    rescue
      nil
    end
  end
end
