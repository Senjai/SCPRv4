# See the Twitter API docs for more available options: https://dev.twitter.com/docs/api/1/get/statuses/user_timeline

module CacheTasks
  class Twitter < Task
    
    DEFAULTS = {
      count:            6, 
      trim_user:        0, 
      include_rts:      1, 
      exclude_replies:  1, 
      include_entities: 0
    }
    
    #---------------
    
    def run      
      if tweets = self.fetch_tweets
        self.cache(tweets, "/shared/widgets/cached/tweets", "twitter:#{@screen_name}")
      end
    end

    #---------------
    
    attr_accessor :verbose
    
    def initialize(screen_name, options={})
      @screen_name  = screen_name
      @options      = options.reverse_merge! DEFAULTS      
    end
    
    #---------------
    
    protected
      def fetch_tweets      
        begin
          self.log "Fetching the latest #{@options[:count]} tweets for #{@screen_name}..."
          tweets = ::Twitter.user_timeline(@screen_name, @options)
          return tweets
        rescue Exception => e
          self.log "Error! The tweets were not cached for #{@screen_name} because of the following exception: \n #{e}"
          return false
        end
      end
    #
  end
end
