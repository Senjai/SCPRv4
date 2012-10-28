class AssetWorker
  
  attr_accessor :verbose
  
  #----------
  
  def initialize
    # grab redis information from cache
    @redis = Redis.connect :url => (Rails.cache.instance_variable_get :@data).id
    self.log("Got redis connection at #{@redis}")
  end
  
  #----------
  
  def work
    # subscribe...
    @redis.subscribe("AHSCPR") do |on|
      on.subscribe do |channel,subscriptions|
        self.log("Subscribed to #{channel}")
      end
      
      on.message do |channel,message|
        # message will be a simple JSON object with an :action and an :id
        # in either case we'll just delete the cache for now
        self.log("got message!")
        obj = JSON.load(message)
        self.log("message is from #{obj['id']}!")
        
        Rails.cache.delete("asset/asset-#{obj['id']}")
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
      $stderr.puts "***[#{Time.now}] #{msg}"
    end
  end
end
