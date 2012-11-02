##
# Election Tweeter
#
# Tweet election results auto-magically!
#
module CacheTasks
  class ElectionTweeter < Task
    PROPS = ["30", "34", "36", "38"]

    #---------------
        
    def run
      self.handle_tweeting
    end
    
    #---------------
    
    def initialize(screen_name)
      @screen_name = screen_name
      @tweeter     = Tweeter.new(screen_name)
      @points      = DataPoint.to_hash(DataPoint.where(group_name: "election"))
      @tweet_extra = @points["tweet_extra"].try(:data_value)
    end

    #---------------
    
    def handle_tweeting
      pres = {
        :prev      => Rails.cache.fetch("data_point:election:president:percent_reporting"),
        :current   => @points["president:percent_reporting"].data_value
      }
      
      cd = { 
        :prev    => Rails.cache.fetch("data_point:election:30th:percent_reporting"),
        :current => @points["30th:percent_reporting"].data_value
      }
      
      props = {
        :prev    => Rails.cache.fetch("data_point:election:props:percent_reporting"),
        :current => @points["props:percent_reporting"].data_value
      }
      
      da = {
        :prev    => Rails.cache.fetch("data_point:election:da:percent_reporting"),
        :current => @points["da:percent_reporting"].data_value
      }
      
      measures = {
        :prev    => Rails.cache.fetch("data_point:election:measures:percent_reporting"),
        :current => @points["measures:percent_reporting"].data_value
      }
      
      if should_tweet?(pres)
        tweet("US President: #{@points["president:obama_electoral_votes"]} Obama, " \
          "#{@points["president:romney_electoral_votes"]} Romney (#{pres[:current]}% reporting)")
        Rails.cache.write("data_point:election:president:percent_reporting", pres[:current])
      end
      
      if should_tweet?(da)
        tweet("LA County DA: #{@points["da:jackson_percent"]}% Jackson, " \
          "#{@points["da:lacey_percent"]}% Lacey (#{da[:current]}% reporting)")
        Rails.cache.write("data_point:election:da:percent_reporting", da[:current])
      end
      
      if should_tweet?(cd)
        tweet("CD 30: #{@points["30th:berman_percent"]}% Berman, " \
          "#{@points["30th:sherman_percent"]}% Sherman (#{cd[:current]}% reporting)")
        Rails.cache.write("data_point:election:30th:percent_reporting", cd[:current])
      end
      
      if should_tweet?(props)
        PROPS.each do |prop|
          tweet("Prop #{prop}: " + @points["props:#{prop}:percent_yes"].to_s + "% Yes, " \
            "" + @points["props:#{prop}:percent_no"].to_s + "% No (#{props[:current]}% reporting)")
        end
        Rails.cache.write("data_point:election:props:percent_reporting", props[:current])
      end
      
      if should_tweet?(measures)
        tweet("Measure J: #{@points["measures:J:percent_yes"]}% Yes, " \
          "#{@points["measures:J:percent_no"]}% No (#{measures[:current]}% reporting)")
        Rails.cache.write("data_point:election:measures:percent_reporting", measures[:current])
      end
    end
    
    #------------
    
    private
        
    def tweet(message)
      self.log "Tweeting: #{message}"
      @tweeter.update "#{message} #{@tweet_extra}"
    end
    
    def should_tweet?(group)
      (group[:current].to_i - group[:prev].to_i) >= 10
    end
  end # ElectionTweeter
end # CacheTasks
