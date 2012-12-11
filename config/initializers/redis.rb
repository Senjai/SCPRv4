# After forking, reconnect any Redis connections
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      Rails.cache.reconnect
    end
  end
end

# Use whatever the environment's cache is for Resque
$redis = Rails.cache.instance_variable_get(:@data)
Resque.redis = $redis

# Every time a job is started, make sure the connection
# to MySQL is okay. This avoids the "MySQL server has gone away"
# error.
Resque.after_fork = Proc.new do
  ActiveRecord::Base.verify_active_connections!
end
