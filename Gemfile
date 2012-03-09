source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'mysql2'

#gem 'redis-content-store', :path => "/Users/eric/projects/scpr/redis-content-store"
gem 'redis-content-store', "3.2.2", :git => "git://github.com/SCPR/redis-content-store.git"

gem 'jquery-rails'
gem 'will_paginate'
gem 'capistrano'
gem 'disqussion', :git => "git://github.com/SCPR/disqussion.git"
gem 'thinking-sphinx', '2.0.10'

gem 'therubyracer'
gem 'newrelic_rpm'

gem "ruby-mp3info"
gem "feedzirra"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "eco"
  gem 'sass-rails'
  gem "compass-rails"
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'oily_png'
end

group :test, :development do 
	gem "rspec-rails"
	gem 'guard-rspec' # Automatically run tests
	gem 'guard-cucumber' # Automatically run tests
	gem "guard-spork"
	gem 'rb-fsevent', require: false # For file-watching on Mac
end

group :test do
  gem 'cucumber-rails', require: false # Integration testing
  gem 'factory_girl_rails' # Factories for test data
  gem 'database_cleaner' # Database cleaning strategy
  gem 'mocha' # cross-framework mocking
#  gem 'launchy' # currently incompatible with rails 3.2
  gem 'capybara' # Acceptance testing
#  gem "spork", "> 0.9.0.rc" # Faster-running tests
end

group :worker do
  gem 'rubypython'
end
