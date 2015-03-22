$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "postino/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "postino"
  s.version     = Postino::VERSION
  s.authors     = ["miguel michelson"]
  s.email       = ["miguelmichelson@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Postino."
  s.description = "TODO: Description of Postino."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_dependency "premailer"
  s.add_dependency "lazy_high_charts"
  s.add_dependency "wicked"
  s.add_dependency "haml"
  s.add_dependency "simple_form"
  s.add_dependency "cocoon"
  s.add_dependency "sidekiq"
  s.add_dependency "kaminari"
  s.add_dependency "mustache"
  s.add_dependency "nokogiri"
  s.add_dependency "aasm"
  s.add_dependency 'bootstrap-sass' #, '3.3.0.0'
  s.add_dependency 'font-awesome-rails' #, '4.3.0.0'
  s.add_dependency 'urlcrypt'
  s.add_dependency 'carrierwave'
  s.add_dependency 'mini_magick'
  s.add_dependency 'fog'
  s.add_dependency 'dotenv-rails'
  s.add_dependency 'coffee-rails'

  s.add_development_dependency "factory_girl"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
end
