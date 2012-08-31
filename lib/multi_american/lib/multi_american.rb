$: << "."

# Dependencies
require "open-uri"

#------------------
# Hard-coded values for Multi-American
# These are from Mercer
module MultiAmerican
  BLOG_ID   = 22
  BLOG_SLUG = 'multi-american'
  AUTHOR_ID = 71 # Leslie's Bio ID, use by default
end

module WP
  def self.cache_namespace
    "wp"
  end
  
  def self.rcache
    @@cache ||= Rails.cache.instance_variable_get(:@data)
  end
  
  # An easy way to use the text helpers
  def self.view
    ActionView::Base.new(ActionController::Base.view_paths, {})
  end
end


#------------------
# Lib files
# Order of groups is important
require 'multi_american/lib/multi_american/builder.rb'

require 'multi_american/lib/multi_american/document.rb'

require 'multi_american/lib/multi_american/node.rb'

require 'multi_american/lib/multi_american/post_base.rb'

# Post types
require 'multi_american/lib/multi_american/post.rb'
require 'multi_american/lib/multi_american/jiffy_post.rb'
require 'multi_american/lib/multi_american/roundup.rb'
require 'multi_american/lib/multi_american/attachment.rb'
require 'multi_american/lib/multi_american/nav_menu_item.rb'

require 'multi_american/lib/multi_american/category.rb'
require 'multi_american/lib/multi_american/tag.rb'

require 'multi_american/lib/multi_american/resque_job.rb'

#------------------
# Setup our resources based on WP classes and 
# remove ones we don't want listed.
ignores = %w{documents nodes builders resque_jobs post_bases}
WP::RESOURCES = WP.constants.select { |c| WP.const_get(c).is_a? Class }
                            .map { |r| r.to_s.demodulize.underscore.pluralize } - ignores
