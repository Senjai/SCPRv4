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
      if homepage = ::Homepage.published.first
        scored_content = homepage.scored_content
      
        self.cache(scored_content[:headlines], "/home/cached/headlines", "home/headlines")
        self.cache(scored_content[:sections], "/home/cached/sections", "home/sections")
      end
      
      true
    end

    add_transaction_tracer :run, category: :task

    #---------------
    
    class << self
      def enqueue
        Resque.enqueue(Job::Homepage)
      end
    end
  end # Homepage
end # CacheTasks
