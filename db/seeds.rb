# Setup permissions based on Outpost's registered models.
Outpost.config.registered_models.each do |resource|
  Permission.create(resource: resource)
end
