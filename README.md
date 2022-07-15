# Unofficial MailerSend integration with Rails

### Setup

1. Add it to your Gemfile
2. Use the adapter:
```ruby
  ActionMailer::Base.delivery_method = :mailersend
```
3. `mailersend-ruby` gem requires `MAILERSEND_API_TOKEN` environment variable,
   so make sure it's set.

### Disclaimer
- The code is terrible
- There are no tests
- It kinda works (as of July 2022)
- Contributions are welcome
