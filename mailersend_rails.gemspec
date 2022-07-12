Gem::Specification.new do |s|
  s.name        = "mailersend_rails"
  s.version     = "0.0.0"
  s.summary     = "Unofficial MailerSend integration with Rails"
  s.description = "A simple hello world gem"
  s.authors     = ["unmanbearpig"]
  s.email       = "me@unmb.pw"
  s.files       = ["lib/mailersend_rails.rb"]
  # s.homepage    =
  #   "https://rubygems.org/gems/hola"
  s.license       = "MIT"

  s.add_dependency 'mailersend-ruby'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'minitest-rails'
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'net-smtp'
end
