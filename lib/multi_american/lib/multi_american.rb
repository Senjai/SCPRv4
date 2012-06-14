$: << "."
require 'rubygems'
require 'active_record'
require 'active_support'
require 'yaml'
require 'logger'
require "nokogiri"
require "net/http"
require "uri"

module WP
  BLOG_ID = 22 # For Multi-American
  BLOG_SLUG = 'multi-american'
  CONTENT_TYPE_ID = 44 # BlogEntry (in mercer)
  
  POST_DEFAULTS = {
    blog_id:      WP::BLOG_ID,
    blog_slug:    WP::BLOG_SLUG,
    is_published: 0
  }
end
require 'multi_american/lib/multi_american/document.rb'
require 'multi_american/lib/multi_american/post.rb'

require 'multi_american/lib/multi_american/jiffy_post.rb'
require 'multi_american/lib/multi_american/attachment.rb'
require 'multi_american/lib/multi_american/nav_menu_item.rb'
require 'multi_american/lib/multi_american/roundup.rb'
require 'multi_american/lib/multi_american/topic.rb'

require 'multi_american/lib/multi_american/author.rb'
require 'multi_american/lib/multi_american/tag.rb'
