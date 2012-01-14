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
        HomeController._cache_homepage(obj['key'])
        self.log("completed homepage caching... back to listening")
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