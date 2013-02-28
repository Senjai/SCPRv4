##
# Election Tweeter
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
    
    CACHE_KEY = 'data_point:election-march2013'
    KEYS = {
      :mayor     => "mayor:percent_reporting"
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
        tweet("Mayor: #{top_two.first}, #{top_two.last} (#{mayor[:current]}% reporting)")
        Rails.cache.write(KEYS[:mayor], mayor[:current])
      end

      if should_tweet?(attorney)
        top_two = build_top_two("attorney")
        tweet("City Attorney: #{top_two.first}, #{top_two.last} (#{attorney[:current]}% reporting)")
        Rails.cache.write(KEYS[:attorney], attorney[:current])
      end
      
      if should_tweet?(measure_a)
        top_two = build_top_two("measure_a")
        tweet("Measure A: #{top_two.first}, #{top_two.last} (#{measure_a[:current]}% reporting)")
        Rails.cache.write(KEYS[:measure_a], measure_a[:current])
      end

      if should_tweet?(lausd_d2)
        top_two = build_top_two("lausd_d2")
        tweet("LAUSD District 2: #{top_two.first}, #{top_two.last} (#{lausd_d2[:current]}% reporting)")
        Rails.cache.write(KEYS[:lausd_d2], lausd_d2[:current])
      end

      if should_tweet?(lausd_d4)
        top_two = build_top_two("lausd_d4")
        tweet("LAUSD District 4: #{top_two.first}, #{top_two.last} (#{lausd_d4[:current]}% reporting)")
        Rails.cache.write(KEYS[:usd_d04], lausd_d4[:current])
      end

      if should_tweet?(lausd_d6)
        top_two = build_top_two("lausd_d6")
        tweet("LAUSD District 6: #{top_two.first}, #{top_two.last} (#{lausd_d6[:current]}% reporting)")
        Rails.cache.write(KEYS[:usd_d06], lausd_d6[:current])
      end
    end
    
    #------------
    
    private
        
    def tweet(message)
      if @twitter_points['auto_tweet'].data_value.downcase == "true"
        self.log "Tweeting: #{message}"
        @tweeter.update "#{message} #{@tweet_append}"
      else
        self.log "auto_tweet turned off. Skipping tweet."
      end
    end
    
    def should_tweet?(group)
      (group[:current].to_i - group[:prev].to_i) >= 10
    end

    def build_top_two(key_prepend)
      @points.select { |p| p.data_key =~ /\A#{key_prepend}:percent_/ && p.data_key !~ /reporting\z/ }
        .sort { |p| p.data_value.to_i }.reverse.first(2)
        .map { |p| 
          title = p.title.split(' ')
          "#{p.data_value}% #{title[1] || title[0]}" 
        }
    end
  end # ElectionTweeter
end # CacheTasks
