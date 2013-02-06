##
# CacheTasks::Homepage
#
# Cache the homepage!
# Pass in an object key to index only that model.
# Without an object key, the entire db is re-indexed.
#
module CacheTasks
  class Homepage < Task
    def run
      @indexer.index
      
      if homepage = ::Homepage.published.first
        scored_content = homepage.scored_content
      
        self.cache(scored_content[:headlines], "/home/cached/headlines", "home/headlines")
        self.cache(scored_content[:sections], "/home/cached/sections", "home/sections")
      end
      
      true
    end

    add_transaction_tracer :run, category: :task

    #---------------
    
    def enqueue
      Resque.enqueue(Job::Homepage, @obj_key.to_s)
    end
    
    #---------------
    
    attr_reader :indexer, :model
    
    def initialize(obj_key=nil)
      models = [ContentByline]

      @obj_key = obj_key
      
      if @model = ContentBase.get_model_for_obj_key(obj_key)
        models.push(model) if ContentBase::CONTENT_CLASSES.include?(@model)
      end
      
      @indexer = Indexer.new(*models)
    end
  end # Homepage
end # CacheTasks
