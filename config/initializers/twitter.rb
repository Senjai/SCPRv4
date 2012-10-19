Twitter.configure do |config|
  config.consumer_key       = API_KEYS['twitter']['consumer_key']
  config.consumer_secret    = API_KEYS['twitter']['consumer_secret']
  config.oauth_token        = API_KEYS['twitter']['access_token']
  config.oauth_token_secret = API_KEYS['twitter']['access_token_secret']
end
