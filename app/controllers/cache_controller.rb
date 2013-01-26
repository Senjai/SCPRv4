##
# CacheController
#
# Cache partials for content.
#
class CacheController < AbstractController::Base
  abstract!
  
  include AbstractController::Logger
  include AbstractController::Rendering
  include AbstractController::Layouts
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  
  helper ApplicationHelper, WidgetsHelper
  
  # Set the view path to "app/views" so that we can cache
  # a partial anywhere under that directory.
  self.view_paths = "app/views"
  
  def render_view(options)
    render options
  end
  
  # Write a partial's output to cache.
  # 
  # Arguments:
  # * content: Array or content
  #            The content to be passed into the partial
  #            Passed in as local variable :content
  #            Local-var name can be overridden with the :local option
  # * partial: String
  #            The partial the render, relative to Rails.root
  # * cache_key: String
  #              The cache key to write to
  def cache(content, partial, cache_key, options={})
    options.reverse_merge!(local: :content)
    cached = render(partial: partial, object: content, as: options[:local])
    write(cache_key, cached)
  end
  
  #---------------------
  
  private
  
  def write(key, value)
    Rails.cache.write(key, value)
    true
  end
end
