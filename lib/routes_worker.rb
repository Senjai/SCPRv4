class RoutesWorker
  # Just reload routes when it gets the signal
  
  attr_accessor :verbose
    
  def initialize(attributes={})
    @redis = Redis.connect :url => (Rails.cache.instance_variable_get :@data).id
    self.log "Connected to Redis: #{@redis}"
  end
    
  def work
    @redis.subscribe("scprv4_routes") do |on|
      on.subscribe do |channel,subscriptions|
        self.log "Subscribed to #{channel}, in #{Rails.env}"
      end
      
      on.message do |channel,message|
        # message is a JSON object:
        # data = {
        #     'reload_routes': "true"
        #     'id': obj.id
        # }
        
        obj = JSON.load(message)
        self.log obj
        
        Scprv4::Application.reload_routes!
        #  That's it!
      end
      
      on.unsubscribe do |channel,subscriptions|
        self.log "Unsubscribed from #{channel}"
      end
    end
  end
    
  def pid
    Process.pid
  end
    
  def log(msg)
    if verbose
      $stderr.puts "*** [#{Time.now}] #{msg}"
    end
  end
end