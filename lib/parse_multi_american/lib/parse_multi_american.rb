$: << "."
require 'rubygems'
require 'active_record'
require 'active_support'
require 'yaml'
require 'logger'
require "nokogiri"
require "net/http"
require "uri"

require File.join(File.dirname(__FILE__), 'parse_multi_american/parser.rb')

module MultiAmerican
  BLOG_ID = 22 # For Multi-American
  INTEGER_NAMEPSACE = "0000"
  CONTENT_TYPE_ID = 44 # BlogEntry (in mercer)
end