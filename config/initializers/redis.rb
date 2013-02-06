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
