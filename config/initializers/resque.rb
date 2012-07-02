# Use whatever the environment's cache is for Resque
Resque.redis = Rails.cache.instance_variable_get(:@data)

# Every time a job is started, make sure the connection
# to MySQL is okay. This avoids the "MySQL server has gone away"
# error.
Resque.after_fork = Proc.new { 
  ActiveRecord::Base.verify_active_connections!  
}