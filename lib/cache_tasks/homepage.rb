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
      
      @homepage      = ::Homepage.published.first
      scored_content = @homepage.scored_content
      
      self.cache(scored_content[:headlines], "/home/cached/headlines", "home/headlines")
      self.cache(scored_content[:sections], "/home/cached/sections", "home/sections")
      true
    end
    
    #---------------
    
    def initialize(obj_key = nil)
      @model   = ContentBase.get_model_for_obj_key(@obj_key)
      @indexer = Indexer.new(@model, ContentByline)
    end
  end # Homepage
end # CacheTasks
