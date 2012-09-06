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
  
  def self.resources
    ignores = %w{documents nodes builders resque_jobs post_bases}
    
    #------------------
    # Setup our resources based on MultiAmerican classes and 
    # remove ones we don't want listed.
    MultiAmerican.constants.select do |c| 
      MultiAmerican.const_get(c).is_a? Class
    end.map do |r| 
      r.to_s.demodulize.underscore.pluralize
    end - ignores
  end
end

#------------------
# Lib files
# Order of groups is important
require 'multi_american/builder.rb'
         
require 'multi_american/document.rb'
         
require 'multi_american/node.rb'
         
require 'multi_american/post_base.rb'

# Post types
require 'multi_american/post.rb'
require 'multi_american/jiffy_post.rb'
require 'multi_american/roundup.rb'
require 'multi_american/attachment.rb'
require 'multi_american/nav_menu_item.rb'
         
require 'multi_american/category.rb'
require 'multi_american/tag.rb'
         
require 'multi_american/resque_job.rb'
