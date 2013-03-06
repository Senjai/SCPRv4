##
# Election Tweeter
#
# March Elections
#
# Tweet election results auto-magically!
#
module CacheTasks
  class ElectionTweeter < Task
    def run
      if @twitter_points['auto_tweet'].data_value.to_s.downcase == "true"
        self.handle_tweeting
      else
        self.log "auto_tweet turned off. Skipping."
      end
    end
    
    #---------------
    
    def initialize(screen_name)
      @screen_name = screen_name
      @tweeter     = Tweeter.new(screen_name)
      @points      = DataPoint.to_hash(DataPoint.where(group_name: "election-march2013"))
      
      @twitter_points = DataPoint.to_hash(DataPoint.where(group_name: "twitter"))
      @tweet_append    = @twitter_points["tweet_append"].try(:data_value)
    end

    #---------------
    
    CACHE_KEY = 'data_point:election-march2013:'
    KEYS = {
      :mayor     => "mayor:percent_reporting",
      :attorney  => "attorney:percent_reporting",
      :measure_a => "measure_a:percent_reporting",
      :lausd_d2  => "lausd:d2:percent_reporting",
      :lausd_d4  => "lausd:d4:percent_reporting",
      :lausd_d6  => "lausd:d6:percent_reporting"
    }

    def handle_tweeting
      mayor = { 
        :prev    => Rails.cache.fetch(CACHE_KEY + KEYS[:mayor]),
        :current => @points[KEYS[:mayor]].data_value
      }
      
      attorney = { 
        :prev    => Rails.cache.fetch(CACHE_KEY + KEYS[:attorney]),
        :current => @points[KEYS[:attorney]].data_value
      }

      measure_a = { 
        :prev    => Rails.cache.fetch(CACHE_KEY + KEYS[:measure_a]),
        :current => @points[KEYS[:measure_a]].data_value
      }
      
      lausd_d2 = { 
        :prev    => Rails.cache.fetch(CACHE_KEY + KEYS[:lausd_d2]),
        :current => @points[KEYS[:lausd_d2]].data_value
      }
      
      lausd_d4 = { 
        :prev    => Rails.cache.fetch(CACHE_KEY + KEYS[:lausd_d4]),
        :current => @points[KEYS[:lausd_d4]].data_value
      }
      
      lausd_d6 = { 
        :prev    => Rails.cache.fetch(CACHE_KEY + KEYS[:lausd_d6]),
        :current => @points[KEYS[:lausd_d6]].data_value
      }

      try_tweet(group: mayor, key_prepend: "mayor", reporting_key: :mayor, title: "Mayor")
      try_tweet(group: attorney, key_prepend: "attorney", reporting_key: :attorney, title: "City Attorney")
      try_tweet(group: measure_a, key_prepend: "measure_a", reporting_key: :measure_a, title: "Measure A")
      try_tweet(group: lausd_d2, key_prepend: "lausd:d2", reporting_key: :lausd_d2, title: "LAUSD District 2")
      try_tweet(group: lausd_d4, key_prepend: "lausd:d4", reporting_key: :lausd_d4, title: "LAUSD District 4")
      try_tweet(group: lausd_d6, key_prepend: "lausd:d6", reporting_key: :lausd_d6, title: "LAUSD District 6")

      true
    end
    
    #------------
    
    private
    
    def try_tweet(options={})
      group         = options[:group]
      key_prepend   = options[:key_prepend]
      reporting_key = options[:reporting_key]
      title         = options[:title]

      if should_tweet?(group)
        top_two = build_top_two(key_prepend)
        Rails.cache.write(CACHE_KEY + KEYS[reporting_key], group[:current])
        tweet("#{title}: #{top_two.first}; #{top_two.last} / #{group[:current]}% reporting;")
      else
        self.log "Threshold not passed for #{key_prepend} (Prev: #{group[:prev]}; Current: #{group[:current]}). Not tweeting."
      end
    end

    def tweet(message)
      self.log "Tweeting: #{message}"
      begin
        @tweeter.update "#{message} #{@tweet_append}"
      rescue Twitter::Error::Forbidden => e
        self.log "Twitter error: #{e}"
      end
    end
    
    def should_tweet?(group)
      tweet = (group[:current].to_i - group[:prev].to_i) >= 10
    end

    def build_top_two(key_prepend)
      @points.select { |k, _| k =~ /\A#{key_prepend}:percent_/ && k !~ /reporting\z/ }
        .sort_by { |p| p[1].data_value.to_i }.reverse.first(2)
        .map { |p| 
          title = p[1].title.split(' ')
          "#{title[1] || title[0]} (#{p[1].data_value.to_i}%)" 
        }
    end
  end # ElectionTweeter
end # CacheTasks
