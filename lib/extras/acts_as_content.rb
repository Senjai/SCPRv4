module ActsAsContent
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
    include InstanceMethods::HasFormat        if !list[:has_format].nil?
    include InstanceMethods::StatusHelpers    if list[:has_status]
    include InstanceMethods::AutoPublishedAt  if !list[:auto_published_at].nil?
    include InstanceMethods::Headline         if !list[:headline].nil?  and list[:headline].to_sym  != :headline
    include InstanceMethods::Body             if !list[:body].nil?      and list[:body].to_sym      != :body

    include InstanceMethods::ObjKey           if list[:obj_key]
    include InstanceMethods::LinkPath         if list[:link_path]
    include InstanceMethods::Comments         if list[:comments]    
    include InstanceMethods::ShortHeadline    if list[:short_headline]
    include InstanceMethods::Teaser           if list[:teaser]
  end

  #----------

  module Generators
    
    module Teaser
      #--------------------
      # Cut down body to get teaser
      def self.generate_teaser(text, length=180)
        stripped_body = ActionController::Base.helpers.strip_tags(text).gsub("&nbsp;"," ").gsub(/\r/,'')
        match = stripped_body.match(/^(.+)/)
        
        if !match
          return ""
        else
          first = match[1]
          if first.length < length
            return first
          else
            # try shortening this paragraph
            short = first.match /^(.{#{length}}\w*)\W/
            return short ? "#{short[1]}..." : first
          end
        end
        
      end # generate_teaser
    end # Teaser
    
  end # Generators
  
  #------------------
  
  module InstanceMethods
    
    module HasFormat
      def has_format?
        self.class.acts_as_content_options[:has_format]
      end
    end
    
    module StatusHelpers
      def killed?
        self.status == ContentBase::STATUS_KILLED
      end
      
      def draft?
        self.status == ContentBase::STATUS_DRAFT
      end
      
      def awaiting_rework?
        self.status == ContentBase::STATUS_REWORK
      end
      
      def awaiting_edits?
        self.status == ContentBase::STATUS_EDIT
      end
      
      def pending?
        self.status == ContentBase::STATUS_PENDING
      end
      
      def published?
        self.status == ContentBase::STATUS_LIVE
      end
    end

    #----------

    module AutoPublishedAt
      def auto_published_at
        self.class.acts_as_content_options[:auto_published_at]
      end
    end

    #----------
    
    module PublishedAt
      def published_at_is_valid_date
        # Chronic#parse returns nil if it can't parse the date.
        # Time#parse raises an error
        Rails.logger.info self.published_at
        unless self.Chronic.parse(self.published_at)
          errors.add(:published_at, "has an invalid format. Format should be: '01/25/2012 05:30pm'")
        end
      end
    end
    
    #----------
    
    module Headline
      def headline
        self.send(self.class.acts_as_content_options[:headline])
      end
    end

    #----------
    
    module Body
      def body
        self.send(self.class.acts_as_content_options[:body])
      end
    end

    #----------
    
    module ObjKey
      def obj_key
        if !self.class.const_defined?(:CONTENT_TYPE)
          raise "obj_key needs CONTENT_TYPE. Missing from #{self.class.name}."
        else
          [self.class::CONTENT_TYPE,self.id].join(":")
        end
      end
    end
    
    #----------
    
    module LinkPath
      def self.included(base)
        if !base.instance_methods.include? :link_path
          # FIXMEL this gets run before the class is fully loaded so it fails.
          # raise "link_path not defined for #{base.name}."
        end
      end
      
      def remote_link_path
        "http://www.scpr.org#{self.link_path}"
      end
    end
    
    #----------
    
    module Comments
      def disqus_identifier
        if !self.respond_to? :obj_key
          raise "disqus_identifer needs obj_key. Missing from #{self.class.name}."
        end
        
        self.obj_key
      end

      def disqus_shortname
        API_KEYS["disqus"]["shortname"]
      end
    end
    
    #----------
    
    module ShortHeadline
      def short_headline
        if !self.respond_to? :headline
          raise "short_headline needs headline. Missing from #{self.class.name}."
        end
        
        if self[:short_headline].present?
          self[:short_headline]
        else
          self.headline
        end
      end
    end

    #----------
    
    module Teaser
      
      def teaser
        if !self.respond_to? :body
          raise "teaser needs body. Missing from #{self.class.name}."
        end

        # If teaser column is present, use it
        # Otherwise try to generate the teaser from the body
        if self[:teaser].present?
          self[:teaser]
        else
          ActsAsContent::Generators::Teaser.generate_teaser(self.body)
        end
      end # teaser
    end # Teaser
  end # InstanceMethods
end # ActsAsContent

ActiveRecord::Base.extend ActsAsContent
