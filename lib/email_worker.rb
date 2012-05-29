class EmailWorker
  # Might eventually be a more generic worker for any interaction with the email cliet API, 
  # but right now it's hardcoded for Breaking News Alerts
  
  attr_accessor :verbose
    
  def initialize
    @redis = Redis.connect :url => (Rails.cache.instance_variable_get :@data).id
    self.log "Connected to Redis: #{@redis}"
  end
    
  def work
    @redis.subscribe("scpremail") do |on|
      on.subscribe do |channel,subscriptions|
        self.log "Subscribed to #{channel}"
      end
      
      on.message do |channel,message|
        # message is just the id of the BreakingNewsAlert that was added
        begin
          obj = JSON.load(message)
          alert = BreakingNewsAlert.find(obj['id'])
          lyris = Lyris.new(API_KEYS["lyris"]["site_id"], API_KEYS["lyris"]["password"], API_KEYS["lyris"]["mlid"], alert)
          lyris.add_message
          lyris.send_message
        rescue
          self.log "BreakingNewsAlert not found"
        end
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
      $stderr.puts "*** #{msg}"
    end
  end
end