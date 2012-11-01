# See the Twitter API docs for more available options: 
# https://dev.twitter.com/docs/api/1/get/statuses/user_timeline

module CacheTasks
  class Twitter < Task
    DEFAULTS = {
      :count            => 6, 
      :trim_user        => 0, 
      :include_rts      => 1, 
      :exclude_replies  => 1, 
      :include_entities => 0
    }
    
    TWITTER_CONSUMER_KEY       = API_KEYS["twitter"]["kpccweb"]["consumer_key"]
    TWITTER_CONSUMER_SECRET    = API_KEYS["twitter"]["kpccweb"]["consumer_secret"]
    TWITTER_OAUTH_TOKEN        = API_KEYS["twitter"]["kpccweb"]["access_token"]
    TWITTER_OAUTH_TOKEN_SECRET = API_KEYS["twitter"]["kpccweb"]["access_token_secret"]
    
    #---------------
    
    def run
      if tweets = self.fetch
        self.cache(tweets, @partial, @cache_key)
        true
      end
    end

    #---------------
        
    def initialize(screen_name, partial="/shared/widgets/cached/tweets", options={})
      @screen_name  = screen_name
      @cache_key    = "twitter:#{screen_name}"
      @partial      = partial
      @options      = options.reverse_merge! DEFAULTS
    end
    
    #---------------
    
    def fetch
      begin
        self.log "Fetching the latest #{@options[:count]} tweets for #{@screen_name}..."
        tweets = client.user_timeline(@screen_name, @options)
        tweets
      rescue Exception => e
        self.log "Error: \n #{e}"
        false
      end
    end
    
    private

    #---------------
    
    def client
      @client ||= begin
        auth = API_KEYS['twitter']['kpccweb']
        ::Twitter::Client.new(
          :consumer_key       => auth["consumer_key"],
          :consumer_secret    => auth["consumer_secret"],
          :oauth_token        => auth["access_token"],
          :oauth_token_secret => auth["access_token_secret"]
        )
      end
    end
  end # Twitter
end # CacheTasks
