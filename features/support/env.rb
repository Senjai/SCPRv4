require 'rubygems'
require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'cucumber/thinking_sphinx/external_world'
require 'chronic'
require 'database_cleaner'
require 'database_cleaner/cucumber'
include FactoryGirl::Syntax::Methods

Capybara.default_selector = :css
ActionController::Base.allow_rescue = false

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

Cucumber::Rails::Database.javascript_strategy = :truncation
Cucumber::Rails::World.use_transactional_fixtures = false
Cucumber::ThinkingSphinx::ExternalWorld.new

Before do
  DatabaseCleaner.start
  FactoryGirl.reload
end

After do
  DatabaseCleaner.clean
end
