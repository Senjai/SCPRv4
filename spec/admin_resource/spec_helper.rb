# ADMIN RESOURCE SPEC HELPER
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require File.expand_path("../../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'chronic'
require 'fakeweb'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/admin_resource/models/*.rb")].each { |f| require f }

FakeWeb.allow_net_connect = false

RSpec.configure do |config|  
  config.use_transactional_fixtures                 = false
  config.infer_base_class_for_anonymous_controllers = true
  
  config.include FactoryGirl::Syntax::Methods
  config.include AdminResource::Helpers
  
  config.before :suite do
    DatabaseCleaner.clean_with :truncation
    load "#{Rails.root}/db/seeds.rb"
    DatabaseCleaner.strategy = :transaction
    FactoryGirl.reload
  end
  
  config.before :each do
    FakeWeb.clean_registry
    DatabaseCleaner.start
    Dir[Rails.root.join("spec/admin_resource/models/*.rb")].each { |f| load f }
  end
  
  config.after :each do
    DatabaseCleaner.clean
  end
  
  config.after :suite do
    #
  end
end
