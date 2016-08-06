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
  s.add_dependency "devise"
  s.add_dependency "devise_invitable"
  s.add_dependency 'omniauth-google-oauth2'
  s.add_dependency "stripe"
  s.add_dependency "stripe_event"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "byebug"
  s.add_development_dependency "figaro"
end
