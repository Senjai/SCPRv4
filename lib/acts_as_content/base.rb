module ActsAsContent
  module Base
    # ## ActsAsContent
    # Includes all the methods necessary for ContentBase objects
    # Use this when you don't want something to inherit from ContentBase,
    # but you want it to act like it does.
    #
    # ### Usage
    #
    #     class Event
    #       acts_as_content
    #     end
    #
    # ### Options
    # Accepts `:only` and `:except` options, each an array of symbols to 
    # whitelist or blacklist, respectively.
    # Everything defaults to `true` unless otherwise noted.
    #
    # * link_path:          Checks for `link_path` and includes `remote_link_path`
    #                       boolean, default: true
    #
    # * obj_key:            Includes `obj_key`
    #                       boolean, default: true
    #
    # * comments:           Includes `disqus_identifier`, `disqus_shortname`, and `has_comments?`
    #                       boolean, default: true
    #
    # * has_format:         Includes `has_format?`
    #                       boolean, default: false
    #
    # * auto_published_at:  Includes `auto_published_at`
    #                       boolean, default: true
    #
    # * published_at:       Includes attr_accessor for `published_at_date` and `published_at_time`,
    #                       allowing you to split those fields out in a form
    #                       Also includes the callback method to combine the two
    #                       boolean, default: true
    #
    # * short_headline:     Includes `short_headline` method
    #                       Uses self[:short_headline]` if present else `headline`
    #                       boolean, default: true
    #
    # * teaser:             Includes `teaser` method
    #                       Uses `self[:teaser]` if present else cuts down `body`
    #                       boolean, default: true
    #
    # * headline:           Pass a method to use for `headline`
    #                       Only use if `object.headline` isn't possible.
    #
    # * body:               Pass a method to use for `body`. 
    #                       Only use if `object.body` isn't possible.
    #
    # For the most part, the options can (and should) be left alone.
    #

    # Provides a reliable way for us to check if 
    # the object has acts_as_content, also useful
    # when stubbed in tests!
    def self.extended(base)
      class << base
        attr_accessor :acting_as_content
      end
      # FIXME This returns nil, not false, for inherited classes
      base.acting_as_content = false
    end

    #-------------------

    def acts_as_content(options={})
      self.acting_as_content = true

      only    = options.delete :only
      except  = options.delete :except

      full_list = {
        link_path:          true,
        obj_key:            true,
        comments:           true,
        has_format:         false,
        auto_published_at:  true,
        published_at:       true, # Not currently being used
        has_status:         true,
        short_headline:     true,
        teaser:             true,
        assets:             true
      }.merge! options

      if only.present?
        list = {}
        only.each { |o| list[o] = true }
      else
        list = full_list

        if except.present?
          except.each { |e| list.delete e }
        end
      end

  #    $stdout.puts "setting acts_as_content_options for #{self.name} with #{list}"
      cattr_accessor :acts_as_content_options
      self.acts_as_content_options = list

      if list[:assets]
        has_many :assets, class_name: "ContentAsset", as: :content, order: "asset_order", dependent: :destroy
      end

      # Check for nil if you want to use the passed-in boolean as the actual value
      include Methods::HasFormat        if !list[:has_format].nil?
      include Methods::StatusHelpers    if list[:has_status]
      include Methods::AutoPublishedAt  if !list[:auto_published_at].nil?
      include Methods::Headline         if !list[:headline].nil?  and list[:headline].to_sym  != :headline
      include Methods::Body             if !list[:body].nil?      and list[:body].to_sym      != :body
              
      include Methods::ObjKey           if list[:obj_key]
      include Methods::LinkPath         if list[:link_path]
      include Methods::Comments         if list[:comments]    
      include Methods::ShortHeadline    if list[:short_headline]
      include Methods::Teaser           if list[:teaser]
    end

    #----------
  end
end

require "acts_as_content/generators"
require 'acts_as_content/methods/has_format'
require 'acts_as_content/methods/comments'
require 'acts_as_content/methods/status_helpers'
require 'acts_as_content/methods/auto_published_at'
require 'acts_as_content/methods/published_at'
require 'acts_as_content/methods/body'
require 'acts_as_content/methods/headline'
require 'acts_as_content/methods/teaser'
require 'acts_as_content/methods/short_headline'
require 'acts_as_content/methods/link_path'
require 'acts_as_content/methods/obj_key'
