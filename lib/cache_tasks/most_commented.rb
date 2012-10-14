module CacheTasks
  class MostCommented < Task
    def run      
      content = self.fetch_most_commented
      self.cache(content, "/shared/widgets/most_popular_commented", "widget/popular_commented")
    end

    #--------------
    
    attr_accessor :verbose
    
    def initialize(forum, interval, options={})
      @forum    = forum
      @interval = interval
    end
    
    #--------------

    protected
      def fetch_most_commented
        content = []
      
        Disqussion::Client.threads.listPopular(forum: @forum, interval: @interval).response.each do |p|
          # find content object
          cobj  = ContentBase.obj_by_key(p.identifiers[0])
          count = p.posts_in_interval
    
          if cobj
            self.log "content, count is #{cobj}, #{count}"
            content << [count,cobj]
          end
        end
      
        return content
      end
    #
  end
end
