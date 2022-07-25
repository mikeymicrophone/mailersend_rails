# frozen_string_literal: true
module MailersendRails
  class RailsMsgToMsMsg
    # Transforms Rails email message to Mailersend::Email
    def self.msg_to_ms_msg(msg)
      ms_msg = Mailersend::Email.new
      ms_msg.add_subject(msg.subject)
      ms_msg.recipients = msg.to_addresses
        .map { |a| rails_addr_to_ms_addr(a) }
        .uniq { |a| a[:email] }
      ms_msg.add_from(rails_addr_to_ms_addr(msg.from_address))
      ms_msg.add_html(msg_html(msg))
      ms_msg.add_text(msg_text(msg))


      # MailerSend doesn't allow same CC/BCC address as TO address,
      # so we're removing duplicates here
      to_emails = ms_msg.recipients.map { |a| a[:email] }
      ms_msg.ccs =
        msg.cc_addresses
        .map { |a| rails_addr_to_ms_addr(a) }
        .uniq { |a| a[:email] }
        .filter { |a| !to_emails.include?(a[:email]) }
      cc_emails = ms_msg.ccs.map { |a| a[:email] }
      ms_msg.bcc = msg.bcc_addresses
        .map { |a| rails_addr_to_ms_addr(a) }
        .uniq { |a| a[:email] }
        .filter { |a| !to_emails.include?(a[:email]) }
        .filter { |a| !cc_emails.include?(a[:email]) }

      if ms_msg.text.nil? && ms_msg.html.nil?
        Rails.logger.warn("Trying to send a message \
                          without plaintext and html: #{msg}")
      end

      ms_msg
    end

    private

    def self.rails_addr_to_ms_addr(raddr)
      name = raddr.display_name || raddr.address
      email = raddr.address
      { name: name, email: email }
    end

    # Get plaintext from Rails email msg
    def self.msg_text(msg)
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
    def self.msg_html(msg)
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
