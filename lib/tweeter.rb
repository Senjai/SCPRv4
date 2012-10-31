##
# Tweeter
# A light wrapper around the Twitter API
# to authenticate and tweet as a user.
#
# The passed-in screen name must have a
# corresponding YAML config in
# config/api_keys.yml under "twitter_defaults"
#
class Tweeter  
  def initialize(screen_name)
    @screen_name = screen_name
  end
  
  #---------------
  
  def tweet(message)
    client.update message
  end

  #---------------
  
  private
  
  def client
    @client ||= begin
      auth = API_KEYS['twitter'][@screen_name]
      Twitter::Client.new(
        :consumer_key       => auth["consumer_key"],
        :consumer_secret    => auth["consumer_secret"],
        :oauth_token        => auth["access_token"],
        :oauth_token_secret => auth["access_token_secret"]
      )
    end
  end
end # Twitter
