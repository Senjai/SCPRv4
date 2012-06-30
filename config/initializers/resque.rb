# Use whatever the environment's cache is for Resque
Resque.redis = Rails.cache.instance_variable_get(:@data)
