# Landlord
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'landlord'
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
$ rails landlord:import_plans
```

Copy Devise and Landlord views/mailers into app

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
