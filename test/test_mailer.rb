require 'minitest/autorun'

require 'rubygems'
require 'base64'
require 'bundler'
require 'bundler/setup'
Bundler.setup(:development)

require 'nokogiri'
require 'mailersend_rails'
require 'rails'
require 'action_mailer'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :mailersend

class TestMailer < ActionMailer::Base
  default from: 'test@example.com'

  def msg(from, to, subject)
    mail(
      to: to,
      from: from,
      subject: subject
    ) do |format|
      format.text { render plain: 'testemail123' }
      format.text { render plain: '<div>testemail123</div>' }
    end
  end
end

class MailerTest < Minitest::Test
  def setup
  end

  def test_text_message
    TestMailer.msg('from@example.com', 'to@exmaple.com', 'testsubj').deliver!
  end
end
