Gem::Specification.new do |s|
  s.name        = "mailersend_rails"
  s.version     = "0.0.1"
  s.summary     = "Unofficial MailerSend integration with Rails"
  s.authors     = ["unmanbearpig"]
  s.email       = "me@unmb.pw"
  s.files       = ["lib/mailersend_rails.rb", "lib/mailer.rb", 'lib/rails_msg_to_ms_msg.rb', 'lib/railtie.rb']
  s.homepage    = "https://github.com/unmanbearpig/mailersend_rails"
  s.license       = "MIT"

  s.add_dependency 'mailersend-ruby'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'minitest-rails'
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'net-smtp'
end
