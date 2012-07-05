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

# Stub AssetHost and other HTTP requests
FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:any, %r{#{Rails.application.config.assethost.server}}, body: File.read("#{Rails.root}/spec/fixtures/assethost.json"))

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = true
  
  config.include FactoryGirl::Syntax::Methods
  config.include ContentBaseHelpers
  config.include RemoteStubs
  config.include LyrisXMLResponse
  config.include DatePathHelper
  
  config.before :suite do
    ThinkingSphinx::Test.start
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
  
  config.after :suite do
    ThinkingSphinx::Test.stop
  end
end
