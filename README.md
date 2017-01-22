# Landlord
Landlord is a Rails engine that provides multi-tenant functionality for your SaaS application. Landlord includes:
* Multi-tenant accounts (with resources scoped to individual accounts)
* Stripe recurring billing (with automated receipts)
* User authentication provided by Devise
* Multiple-account membership for users (with roles)
* Custom account/user settings provided by Ledermann Rails Settings
* Custom user/role permissions provided by Pundit

## Running the dummy test app
Clone this repo, navigate to the repo root path in your terminal/command prompt, then run:
```bash
$ bundle install
$ rails db:migrate
```

Update `/test/dummy/config/application.yml` with your Stripe/Google OAuth API keys:
```ruby
stripe_api_key: your_value_goes_here
stripe_publishable_key: your_value_goes_here
stripe_webhook_secret: your_value_goes_here
google_client_id: your_value_goes_here
google_client_secret: your_value_goes_here
```

Then run:
```bash
$ cd test/dummy
$ rails landlord:import_plans
$ rails s
```

Navigate to [http://localhost:3000/new](http://localhost:3000/new) to create a new account

Notes:
* You may want to run a local mail server such as https://mailcatcher.me/ to receive signup emails
* Your local dev server must be publicly accessible in order to use Google OAuth
* Your local dev server must be publicly accessible in order to receive Stripe billing webhooks

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
