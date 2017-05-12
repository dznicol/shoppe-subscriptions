$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "shoppe/subscriptions/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shoppe-subscriptions"
  s.version     = Shoppe::Subscriptions::VERSION
  s.authors     = ["David Nicol"]
  s.email       = ["dznicol@gmail.com"]
  s.homepage    = "TODO: Add home page for shoppe-subscriptions"
  s.summary     = %q{Add (Stripe) subscriptions to shoppe, for now using Stripe webhooks.}
  s.description = %q{Add (Stripe) subscriptions to shoppe, for now using Stripe webhooks.}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "shoppe"
  s.add_dependency "stripe", "~> 2.8.0"
  s.add_dependency "stripe_event"

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec"
end
