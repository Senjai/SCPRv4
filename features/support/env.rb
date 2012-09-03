require 'rubygems'
require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'cucumber/thinking_sphinx/external_world'
require 'chronic'
require 'database_cleaner'
require 'database_cleaner/cucumber'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

World(FactoryGirl::Syntax::Methods, FormFillers, DatePathHelper, AdminResource::Helpers)

Capybara.default_selector           = :css
ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy            = :transaction

Cucumber::Rails::Database.javascript_strategy     = :truncation
Cucumber::Rails::World.use_transactional_fixtures = false

Cucumber::ThinkingSphinx::ExternalWorld.new
DatabaseCleaner.clean_with :truncation
load "#{Rails.root}/db/seeds.rb"
FactoryGirl.reload

Before do
  ActionMailer::Base.deliveries = []
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
  Rails.cache.clear
end
