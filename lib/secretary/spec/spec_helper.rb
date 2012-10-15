# SECRETARY SPEC HELPER
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require File.expand_path("../../../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'chronic'

Dir[Rails.root.join("spec/support/**/*.rb")].each           { |f| require f }
Dir[Rails.root.join("lib/secretary/spec/models/*.rb")].each { |f| require f }
Dir[Rails.root.join("lib/secretary/spec/db/*.rb")].each     { |f| require f }

# Have to overwrite user_class for tests until this is extracted
# Because when the application is initialized it sets the user_class
# to ::AdminUser
Secretary.config.user_class = "::User"
load "lib/secretary/version.rb"

RSpec.configure do |config|
  config.include RemoteStubs
  
  config.use_transactional_fixtures                 = false
  config.infer_base_class_for_anonymous_controllers = true
    
  config.before :suite do
    ActiveRecord::Base.establish_connection("isolated")
    DatabaseCleaner.clean_with :truncation
    migration = -> { SecretaryMigration.new.up }
    silence_stream STDOUT, &migration
    DatabaseCleaner.strategy = :truncation
    Dir[Rails.root.join("lib/secretary/spec/models/*.rb")].each { |f| load f }
  end
  
  config.before :each do
  end
  
  config.after :each do
    DatabaseCleaner.clean
  end
  
  config.after :suite do
    #
  end
end
