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
          alert = BreakingNewsAlert.find(message)
          self.log "BreakingNewsAlert is '#{alert.headline}'"
          lyris = Lyris.new(API_KEYS["lyris"]["site_id"], API_KEYS["lyris"]["password"], API_KEYS["lyris"]["mlid"], alert)
          self.log "Adding message..."
          lyris.add_message
          self.log "Sending message..."
          lyris.send_message
          self.log "Done."
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