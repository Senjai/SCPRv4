$: << "."

module CacheTasks
  def self.view
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.extend ApplicationHelper
    view.extend WidgetsHelper
  end
  
  class Task    
    def cache(content, partial, cache_key)
      cached = CacheTasks.view.render(partial: partial, object: content, as: :content)
      Rails.cache.write(cache_key, cached)
    end
    
    def log(message)
      message = "*** #{message}"
      
      # Rails log always gets it
      Rails.logger.info message
      
      # STDOUT only gets it if requested
      if @verbose
        puts message
      end
    end
  end
end

require 'cache_tasks/most_commented'
require 'cache_tasks/most_viewed'
require 'cache_tasks/twitter'
