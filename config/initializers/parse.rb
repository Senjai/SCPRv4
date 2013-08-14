Parse.init(Rails.application.config.api['parse'].symbolize_keys)

# We don't have a cacert on our servers. 
Parse.client.session.insecure = true
