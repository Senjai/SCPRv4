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
      self.handle_tweeting
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

      if should_tweet?(mayor)
        top_two = build_top_two("mayor")
        Rails.cache.write(CACHE_KEY + KEYS[:mayor], mayor[:current])
        tweet("Mayor: #{top_two.first}; #{top_two.last} / #{mayor[:current]}% reporting;")
      else
        self.log "Threshold not passed for mayor (Prev: #{mayor[:prev]}; Current: #{mayor[:current]}). Not tweeting."
      end

      if should_tweet?(attorney)
        top_two = build_top_two("attorney")
        Rails.cache.write(CACHE_KEY + KEYS[:attorney], attorney[:current])
        tweet("City Attorney: #{top_two.first}; #{top_two.last} / #{attorney[:current]}% reporting;")
      else
        self.log "Threshold not passed for attorney (Prev: #{attorney[:prev]}; Current: #{attorney[:current]}). Not tweeting."
      end
      
      if should_tweet?(measure_a)
        top_two = build_top_two("measure_a")
        Rails.cache.write(CACHE_KEY + KEYS[:measure_a], measure_a[:current])
        tweet("Measure A: #{top_two.first}; #{top_two.last} / #{measure_a[:current]}% reporting;")
      else
        self.log "Threshold not passed for measure_a (Prev: #{measure_a[:prev]}; Current: #{measure_a[:current]}). Not tweeting."
      end

      if should_tweet?(lausd_d2)
        top_two = build_top_two("lausd:d2")
        Rails.cache.write(CACHE_KEY + KEYS[:lausd_d2], lausd_d2[:current])
        tweet("LAUSD District 2: #{top_two.first}; #{top_two.last} / #{lausd_d2[:current]}% reporting;")
      else
        self.log "Threshold not passed for lausd_d2 (Prev: #{lausd_d2[:prev]}; Current: #{lausd_d2[:current]}). Not tweeting."
      end

      if should_tweet?(lausd_d4)
        top_two = build_top_two("lausd:d4")
        Rails.cache.write(CACHE_KEY + KEYS[:lausd_d4], lausd_d4[:current])
        tweet("LAUSD District 4: #{top_two.first}; #{top_two.last} / #{lausd_d4[:current]}% reporting;")
      else
        self.log "Threshold not passed for lausd_d4 (Prev: #{lausd_d4[:prev]}; Current: #{lausd_d4[:current]}). Not tweeting."
      end

      if should_tweet?(lausd_d6)
        top_two = build_top_two("lausd:d6")
        Rails.cache.write(CACHE_KEY + KEYS[:lausd_d6], lausd_d6[:current])
        tweet("LAUSD District 6: #{top_two.first}; #{top_two.last} / #{lausd_d6[:current]}% reporting;")
      else
        self.log "Threshold not passed for lausd_d6 (Prev: #{lausd_d6[:prev]}; Current: #{lausd_d6[:current]}). Not tweeting."
      end

      true
    end
    
    #------------
    
    private
        
    def tweet(message)
      if @twitter_points['auto_tweet'].data_value.to_s.downcase == "true"
        self.log "Tweeting: #{message}"
        begin
          @tweeter.update "#{message} #{@tweet_append}"
        rescue Twitter::Error::Forbidden => e
          self.log "Twitter error: #{e}"
        end
      else
        self.log "auto_tweet turned off. Skipping tweet."
      end
    end
    
    def should_tweet?(group)
      tweet = (group[:current].to_i - group[:prev].to_i) >= 10
    end

    def build_top_two(key_prepend)
      @points.select { |k, _| k =~ /\A#{key_prepend}:percent_/ && k !~ /reporting\z/ }
        .sort { |p| p[1].data_value.to_i }.reverse.first(2)
        .map { |p| 
          title = p[1].title.split(' ')
          "#{title[1] || title[0]} (#{p[1].data_value.to_i}%)" 
        }
    end
  end # ElectionTweeter
end # CacheTasks
