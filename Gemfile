source 'http://rubygems.org'

gem 'rails', '3.2.0'

gem 'mysql2'

#gem 'redis-content-store', :path => "/Users/eric/projects/redis-content-store"
gem 'redis-content-store', :git => "git://github.com/SCPR/redis-content-store.git"

gem 'jquery-rails'
gem 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git'
gem 'capistrano'
gem 'disqussion', :git => "git://github.com/SCPR/disqussion.git"
gem 'thinking-sphinx', '2.0.10'

gem 'therubyracer'
gem 'newrelic_rpm'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "eco"
  gem 'sass-rails', "  ~> 3.2.3"
  gem "compass-rails"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
  gem 'oily_png'
end

group :test, :development do 
	gem "rspec-rails"
	gem 'guard-rspec'
	gem 'guard-cucumber'
	gem 'rb-fsevent', require: false
end

group :test do
#  # Pretty printed test output
#  gem 'turn', :require => false
  gem 'cucumber-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
#  gem 'launchy'
  gem 'capybara'
  gem 'webrat'
end

group :worker do
  gem 'rubypython'
end
