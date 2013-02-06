Resque.redis = $redis || Rails.cache.instance_variable_get(:@data)

# Register fork actions
# Includes NewRelic monitoring
# More information: https://newrelic.com/docs/ruby/resque-instrumentation
Resque.before_first_fork do
  NewRelic::Agent.manual_start(:dispatcher   => :resque,
                               :sync_startup => true,
                               :start_channel_listener => true,
                               :report_instance_busy => false)
end

Resque.before_fork do |job|
  NewRelic::Agent.register_report_channel(job.object_id)
end

Resque.after_fork do |job|
  # Every time a job is started, make sure the connection
  # to MySQL is okay. This avoids the "MySQL server has gone away"
  # error.
  ActiveRecord::Base.verify_active_connections!
  NewRelic::Agent.after_fork(:report_to_channel => job.object_id)
end
