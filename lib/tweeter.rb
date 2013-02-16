##
# Tweeter
# A light wrapper around the Twitter API
# to authenticate as a twitter user and
# perform actions as that user.
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
  
  def method_missing(method, *args, &block)
    client.send(method, *args)
  end
  
  private
  
  def client
    @client ||= begin
      auth = Rails.application.config.api['twitter'][@screen_name]
      Twitter::Client.new(
        :consumer_key       => auth["consumer_key"],
        :consumer_secret    => auth["consumer_secret"],
        :oauth_token        => auth["access_token"],
        :oauth_token_secret => auth["access_token_secret"]
      )
    end
  end
end # Tweeter
