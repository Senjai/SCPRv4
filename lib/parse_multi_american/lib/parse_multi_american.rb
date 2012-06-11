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
  INTEGER_NAMEPSACE = "0000"
  CONTENT_TYPE_ID = 44 # BlogEntry (in mercer)
end

require File.join(File.dirname(__FILE__), 'parse_multi_american/attachment.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/author.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/jiffy_post.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/nav_menu_item.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/parser.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/post.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/roundup.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/tag.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/tagged_item.rb')
require File.join(File.dirname(__FILE__), 'parse_multi_american/topic.rb')

