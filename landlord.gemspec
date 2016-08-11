$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "landlord/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "landlord"
  s.version     = Landlord::VERSION
  s.authors     = ["Jeremy Kratz"]
  s.email       = ["jwkratz@gmail.com"]
  s.homepage    = "https://github.com/jwkratz/landlord"
  s.summary     = "Rails engine for managing multi-tenant SaaS applications"
  s.description = "Rails engine for managing multi-tenant SaaS applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "devise"                 # User authentication
  s.add_dependency "devise_invitable"       # Allow Devise users to be invited
  s.add_dependency "omniauth-google-oauth2" # Google OAuth2 provider for Devise
  s.add_dependency "pundit"                 # User permission policies
  s.add_dependency "stripe"                 # Billing
  s.add_dependency "stripe_event"           # Process incoming webhooks from Stripe

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
  s.add_development_dependency "figaro"
end
