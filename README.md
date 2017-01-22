# Landlord
Short description and motivation.

## Running the dummy test app
1. Clone this repo
2. Open `/test/dummy` in your terminal/command prompt
```bash
$ bundle install
$ bundle exec figaro install
```

Update `/test/dummy/config/application.yml` with API keys for Stripe and Google OAuth:
```ruby
stripe_api_key: your_value_goes_here
stripe_publishable_key: your_value_goes_here
stripe_webhook_secret: your_value_goes_here
google_client_id: your_value_goes_here
google_client_secret: your_value_goes_here
```

Then execute:
```bash
$ rails landlord:install:migrations
$ rails db:migrate
$ rails landlord:import_plans
$ rails s
```

Navigate to http://localhost:3000/new to create a new account (note: be sure to start a local mail server such as https://mailcatcher.me/ to receive signup emails)

## Installation within your application
Add this line to your application's Gemfile:

```ruby
gem 'landlord'
gem 'figaro'
```

And then execute:
```bash
$ bundle install
$ bundle exec figaro install
```

Setup Google OAuth2: https://github.com/zquestz/omniauth-google-oauth2
Add your Google API keys to `config/application.yml`
Add your Stripe API keys to `config/application.yml`

Then execute:
```bash
$ rails landlord:install:migrations
$ rails db:migrate
$ rails landlord:import_plans
```

Copy `app/views/devise` and `app/views/landlord` from the Landlord gem directory to your application's `app/views` directory

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
