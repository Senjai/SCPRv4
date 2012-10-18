module CacheTasks
  class PopularThread
    attr_accessor :object, :thread, :posts
    
    def initialize(object, thread)
      @object = object
      @thread = thread
      @posts  = thread['posts']
    end
  end
  
  #--------------
  
  class MostCommented < Task
    def run      
      content = self.fetch_most_commented
      self.cache(content, "/shared/widgets/cached/most_popular_commented", "widget/popular_commented")
    end

    #--------------
    
    attr_accessor :verbose
    
    def initialize(forum, interval, api_key, options={})
      @forum    = forum
      @interval = interval
      @api_key  = api_key
    end
    
    #--------------

    protected
      def fetch_most_commented
        content = []

        response = connection.get do |request|
          request.url "/api/3.0/threads/listPopular.json", 
            :forum    => @forum, 
            :interval => @interval, 
            :api_key  => @api_key
          #
        end
        
        response.body['response'].each do |thread|
          if object = ContentBase.obj_by_key(thread['identifiers'].first)
            popular = PopularThread.new(object, thread)
            self.log "Content: #{object.obj_key}, Count: #{popular.posts}"
            content.push popular
          end          
        end
        
        content
      end
            
      def connection
        options = {
          :headers => {'Accept' => "application/json", 'User-Agent' => "SCPR.org"},
          :ssl     => { verify: false },
          :url     => "https://disqus.com"
        }

        Faraday.new(options) do |builder|
          builder.use Faraday::Response::ParseJson
          builder.adapter Faraday.default_adapter
        end
      end
    #
  end
end
