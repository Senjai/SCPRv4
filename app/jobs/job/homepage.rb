##
# Homepage
#
# Note that this job class inherits from CacheTask,
# since it is actually a CacheTask, just on a different
# queue.
#
# We can't use the Index job directly because the Homepage
# caching needs to be indexed right before it caches,
# so we can't enqueue just the indexing. Indexer#index
# needs to be called directly, so we have to enqueue the
# entire CacheTasks::Homepage job onto the same queue as
# the other Sphinx indexing tasks!
#
module Job
  class Homepage < Base
    # This job needs to be on the sphinx queue so
    # that it runs *after* a sphinx index has
    # occurred, because the homepage caching relies
    # on an up-to-date index.
    @queue = "#{namespace}:sphinx"
    
    def self.perform
      task = CacheTasks::Homepage.new
      task.run
      self.log "Performed Homepage caching"
    end
  end
end
