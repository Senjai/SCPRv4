Resque.redis = $redis || Rails.cache.instance_variable_get(:@data)

# Register fork actions
# Includes NewRelic monitoring
# More information: https://newrelic.com/docs/ruby/resque-instrumentation
Resque.after_fork do |job|
  # Every time a job is started, make sure the connection
  # to MySQL is okay. This avoids the "MySQL server has gone away"
  # error.
  ActiveRecord::Base.verify_active_connections!
end
