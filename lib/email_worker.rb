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
        # Mercer is doing boolean checking, but we'll do it here too just to be extra-safe.
        sleep 5 # make sure the transaction is finished in mercer

        obj = JSON.load(message)
        alert = BreakingNewsAlert.find(obj['id'])
        alert.async_publish_email if alert.should_send_email?
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
