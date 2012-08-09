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
  #
  # * obj_key:            Includes `obj_key`
  #
  # * comments:           Includes `disqus_identifier`, `disqus_shortname`, and `has_comments?`
  #
  # * has_format:         Includes `has_format?`
  #                       true or false, pass `nil` if not wanted.
  #                       Default: false
  #
  # * auto_published_at:  Includes `auto_published_at`
  #                       true or false, pass `nil` if no wanted
  #
  # * short_headline:     Includes `short_headline` 
  #                       Uses self[:short_headline]` if present else `headline`
  #
  # * teaser:             Includes `teaser` 
  #                       Uses `self[:teaser]` if present else cuts down `body`
  #
  # * headline:           Pass a method to use for `headline`
  #                       Only use if `object.headline` isn't possible.
  #
  # * body:               Pass a method to use for `body`. 
  #                       Only use if `object.body` isn't possible.
  #
  # For the most part, the options can (and should) be left alone.
  #
  def acts_as_content(options={})
    only    = options.delete :only
    except  = options.delete :except
    
    full_list = {
      link_path:          true,
      obj_key:            true,
      comments:           true,
      has_format:         false,
      auto_published_at:  true,
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
    
    cattr_accessor :acts_as_content_options
    self.acts_as_content_options = list
    
    if list[:assets]
      has_many :assets, class_name: "ContentAsset", as: :content, order: "asset_order", dependent: :destroy
    end
    
    include InstanceMethods::HasFormat        if !list[:has_format].nil?
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

  module InstanceMethods
    
    module HasFormat
      def has_format?
        self.class.acts_as_content_options[:has_format]
      end
    end

    #----------

    module AutoPublishedAt
      def auto_published_at
        self.class.acts_as_content_options[:auto_published_at]
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
        
        if self[:teaser].present?
          self[:teaser]
        else
          generate_teaser
        end  
      end # teaser
      
      private
        #--------------------
        # Cut down body to get teaser
        def generate_teaser
          length = 180
          first_paragraph = /^(.+)/.match(ActionController::Base.helpers.strip_tags(self.body).gsub("&nbsp;"," ").gsub(/\r/,''))

          if first_paragraph
            if first_paragraph[1].length < length
              # cool, return this
              return first_paragraph[1]
            else
              # try shortening this paragraph
              short = /^(.{#{length}}\w*)\W/.match(first_paragraph[1])
              return short ? "#{short[1]}..." : first_paragraph[1]
            end
          else
            return ""
          end
        end # generate_teaser
      # private
    end # Teaser
  end # InstanceMethods
end # ActsAsContent

ActiveRecord::Base.extend ActsAsContent
