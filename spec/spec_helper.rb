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
AH_JSON = File.read("#{Rails.root}/spec/fixtures/assethost.json")

RSpec.configure do |config|  
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = true
  
  config.include FactoryGirl::Syntax::Methods
  config.include ContentBaseHelpers
  config.include RemoteStubs
  config.include LyrisXMLResponse
  config.include DatePathHelper
  config.include StubTime
  
  config.before :suite do
    DatabaseCleaner.clean_with :truncation
    load "#{Rails.root}/db/seeds.rb"
    DatabaseCleaner.strategy = :transaction
    FactoryGirl.reload
    ThinkingSphinx::Test.start
  end
  
  config.before :each do
    FakeWeb.clean_registry
    FakeWeb.register_uri(:any, %r|a\.scpr\.org|, body: AH_JSON)
    DatabaseCleaner.start
  end
  
  config.after :each do
    DatabaseCleaner.clean
    Rails.cache.clear
  end
  
  config.after :suite do
    ThinkingSphinx::Test.stop
  end
end
