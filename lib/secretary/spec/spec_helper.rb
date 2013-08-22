# SECRETARY SPEC HELPER
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require File.expand_path("../../../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each           { |f| require f }
Dir[Rails.root.join("lib/secretary/spec/models/*.rb")].each { |f| require f }
Dir[Rails.root.join("lib/secretary/spec/db/*.rb")].each     { |f| require f }

# Have to overwrite user_class for tests until this is extracted
# Because when the application is initialized it sets the user_class
# to ::AdminUser
Secretary.config.user_class = "::User"
silence_warnings { load "lib/secretary/version.rb" }

RSpec.configure do |config|
  config.include RemoteStubs
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = true
    
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
    ActiveRecord::Base.establish_connection("isolated")
    migration = -> { SecretaryMigration.new.up }
    silence_stream STDOUT, &migration
    Dir[Rails.root.join("lib/secretary/spec/models/*.rb")].each { |f| load f }
  end
  
  config.before do
    DatabaseCleaner.start
  end
  
  config.after do
    DatabaseCleaner.clean
  end
end
