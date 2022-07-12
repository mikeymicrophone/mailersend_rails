require 'rails/railtie'
require 'mailersend-ruby'
require 'mailer'

module MailersendRails
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:action_mailer) do
      add_delivery_method :mailersend, MailersendRails::Mailer
    end
  end
end
