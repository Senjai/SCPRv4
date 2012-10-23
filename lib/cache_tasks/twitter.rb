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
    
    #---------------
    
    def run
      if tweets = self.fetch
        self.cache(tweets, @partial, @cache_key)
        true
      end
    end

    #---------------
    
    attr_accessor :verbose
    
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
        tweets = ::Twitter.user_timeline(@screen_name, @options)
        tweets
      rescue Exception => e
        self.log "Error: \n #{e}"
        false
      end
    end
  end # Twitter
end # CacheTasks
