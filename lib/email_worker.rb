class EmailWorker
  # Might eventually be a more generic worker for any interaction with the email cliet API, 
  # but right now it's hardcoded for Breaking News Alerts
  
  attr_accessor :verbose
    
  def initialize(attributes={})
    @redis = Redis.connect :url => (Rails.cache.instance_variable_get :@data).id
    self.log "Connected to Redis: #{@redis}"
  end
    
  def work
    @redis.subscribe("scpremail") do |on|
      on.subscribe do |channel,subscriptions|
        self.log "Subscribed to #{channel}, in #{Rails.env}"
      end
      
      on.message do |channel,message|
        # message is a JSON object:
        # data = {
        #     'key': obj.obj_key(),
        #     'id': obj.id,
        #     'published': obj.is_published,
        #     'send_email': obj.send_email,
        #     'email_sent': obj.email_sent
        # }
        # All we really need is the ID, because mercer is doing the boolean checking.
        
        obj = JSON.load(message)
        self.log "obj is #{obj}"
        alert = BreakingNewsAlert.find(obj['id'])
        self.log "alert is #{alert}"
        
        # Check just incase
        if alert.is_published and alert.send_email and !alert.email_sent
          lyris = Lyris.new(alert)
          if lyris.add_message and lyris.send_message
            alert.update_attribute(:email_sent, true)
            self.log "Set email_sent=true for #{alert}. Finished."
          end
        else
          self.log "Alert not ready to send e-mail. Check attributes."
          return false
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