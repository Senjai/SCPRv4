module TwitterCacher

  def cache_tweets(*screen_names)
    options = screen_names.last.is_a?(Hash) ? screen_names.pop : {}
    options.reverse_merge!(count: 5, trim_user: 0, include_rts: 1, exclude_replies: 1, include_entities: 0)
    return "A request for that amount of tweets is going to upset Twitter. Keep it under 150/hour." if (screen_names.length * options[:count].to_i) > 150
    
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view # Keeps format_date happy & includes Twitter::AutoLink
      include ApplicationHelper
    end
    
    begin
      screen_names.each do |screen_name|
        puts "Fetching the latest #{options[:count]} tweets for #{screen_name}..."
        tweets = Twitter.user_timeline(screen_name, options)
        puts "Caching #{tweets.length} tweets..."
        Rails.cache.write(
          "twitter:#{screen_name}", 
           view.render("shared/widgets/cached/tweets", tweets: tweets)
        )
        puts "Done!"
      end
    rescue Exception => e
      puts "Error! The tweets were not cached because of the following exception: \n #{e}"
    end
  end
  
end