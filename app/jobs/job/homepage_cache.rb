##
# HomepageCache
#
# This needs to be on the sphinx queue
# run after sphinx is indexed... otherwise
# it could run before and have out of date objects.
module Job
  class HomepageCache < Base
    # This job needs to be on the sphinx queue so
    # that it runs *after* a sphinx index has
    # occurred, because the homepage caching relies
    # on an up-to-date index.
    @queue = "#{namespace}:sphinx"
    
    def self.perform
      if homepage = ::Homepage.published.first
        scored_content = homepage.scored_content
        self.cache(scored_content, "/home/cached/sections", "home/sections")
      end
    end
  end
end
