require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'thinking_sphinx/test'
require 'database_cleaner'
require 'chronic'
require 'fakeweb'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  
  config.include FactoryGirl::Syntax::Methods
  config.include ContentBaseHelpers
  config.include RemoteStubs
  config.include LyrisXMLResponse
  
  config.before :all do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
    FactoryGirl.reload
  end

  config.before :each do
    FakeWeb.clean_registry
    DatabaseCleaner.start
  end
  
  config.after :each do
    DatabaseCleaner.clean
  end
end
