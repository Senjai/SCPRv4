# Make Resque use the same Redis instance as the rest of the app
Resque.redis = Rails.cache.instance_variable_get(:@data)
