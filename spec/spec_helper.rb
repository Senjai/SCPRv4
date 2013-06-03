ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
SimpleCov.start 'rails'

require 'rubygems'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'thinking_sphinx/test'
require 'database_cleaner'
require 'chronic'
require 'fakeweb'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/fixtures/db/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/fixtures/models/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  
  config.include ActionView::TestCase::Behavior, example_group: { file_path: %r{spec/presenters} }
  config.include FactoryGirl::Syntax::Methods
  config.include ThinkingSphinxHelpers
  config.include RemoteStubs
  config.include PresenterHelper
  config.include DatePathHelper
  config.include StubTime
  config.include StubPublishingCallbacks
  config.include AudioCleanup
  config.include FormFillers,           type: :feature
  config.include AuthenticationHelper,  type: :feature
  
  config.before :suite do
    DatabaseCleaner.clean_with :truncation, { except: STATIC_TABLES }
    load "#{Rails.root}/db/seeds.rb"
    DatabaseCleaner.strategy = :transaction
    migration = -> { FixtureMigration.new.up }
    silence_stream STDOUT, &migration
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end
  
  config.before type: :feature do
    DatabaseCleaner.strategy = :truncation, { except: STATIC_TABLES }
  end
  
  config.before :all do
    DeferredGarbageCollection.start
  end

  config.before :each do
    FakeWeb.clean_registry
    FakeWeb.load_callback
    DatabaseCleaner.start
  end
    
  config.after :each do
    DatabaseCleaner.clean
    Rails.cache.clear
  end

  config.after :all do
    DeferredGarbageCollection.reconsider
  end
  
  config.after :suite do
    FileUtils.rm_rf Rails.application.config.scpr.media_root.join("audio/upload")
  end
end
