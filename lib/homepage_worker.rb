class HomepageWorker
  
  attr_accessor :verbose
  
  #----------
  
  def initialize
    # do nothing?
    
    # grab redis information from cache
    @redis = Redis.connect :url => (Rails.cache.instance_variable_get :@data).id
    self.log("Got redis connection at #{@redis}")
  end
  
  #----------
  
  def work
    # subscribe...
    @redis.subscribe("scprcontent") do |on|
      on.subscribe do |channel,subscriptions|
        self.log("Subscribed to #{channel}")
      end
      
      on.message do |channel,message|
        # message will be a simple JSON object with a :key and an :action
        # right now all we care about is the key
        self.log("got message!")
        obj = JSON.load(message)
        self.log("message is from #{obj['key']}!")
        
        if obj["key"] =~ /:new$/
          # these are keys like "contentbase:new" and "news/story:new"
          # we'll just filter them out for now
          next
        end
        
        # cache the homepage when the homepage is saved, new content is published, or published 
        # content is updated and saved
        
        if obj['key'] == "layout/homepage" || obj['action'] == 'publish' || obj['action'] == 'unpublish' || obj['status'] == ContentBase::STATUS_LIVE
          self.log("triggering caching based on action '#{obj['action']}' and status '#{obj['status']}'")
          HomeController._cache_homepage(obj['key'])
          self.log("completed homepage caching... back to listening")
        end
      end
      
      on.unsubscribe do |channel,subscriptions|
        self.log("Unsubscribed from #{channel}")
      end
    end
  end
  
  #----------
  
  def pid
    Process.pid
  end
  
  #----------
  
  def log(msg)
    if verbose
      $stderr.puts "*** #{msg}"
    end
  end
end