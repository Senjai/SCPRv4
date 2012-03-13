class ContentBase < ActiveRecord::Base
  include ApplicationHelper
  
  self.abstract_class = true
  
  STATUS_KILLED   = -1
  STATUS_DRAFT    = 0
  STATUS_REWORK   = 1
  STATUS_EDIT     = 2
  STATUS_PENDING  = 3
  STATUS_LIVE     = 5
  
  STATUS_TEXT = {
      STATUS_KILLED:  "Killed",
      STATUS_DRAFT:   "Draft",
      STATUS_REWORK:  "Awaiting Rework",
      STATUS_EDIT:    "Awaiting Edits",
      STATUS_PENDING: "Pending",
      STATUS_LIVE:    "Published"
  }
  
  CONTENT_CLASSES = {
    'news/story'    => "NewsStory",
    'shows/segment' => "ShowSegment",
    #'shows/episode' => "ShowEpisode",
    'blogs/entry'   => "BlogEntry",
    'video/shell' => "VideoShell",
    'content/shell' => "ContentShell"
  }
  
  CONTENT_MATCHES = {
    %r{^/news/\d+/\d\d/\d\d/(\d+)/.*}                => 'news/story',
    %r{^/admin/news/story/(\d+)/}                    => 'news/story',
    %r{^/blogs/[-_\w]+/\d+/\d\d/\d\d/(\d+)/.*}       => 'blogs/entry',
    %r{^/admin/blogs/entry/(\d+)/}                   => 'blogs/entry',
    %r{^/programs/[\w_-]+/\d{4}/\d\d/\d\d/(\d+)/.*}  => 'shows/segment',
    %r{^/admin/shows/segment/(\d+)/}                 => 'shows/segment',
    %r{^/admin/contentbase/contentshell/(\d+)/}      => 'content/shell'
  }

  # All ContentBase objects have assets and alarms
  has_many :assets, :class_name => "ContentAsset", :as => :content, :order => "asset_order asc"
  has_many :bylines, :class_name => "ContentByline", :as => :content
  
  has_many :brels, :class_name => "Related", :as => :content
  has_many :frels, :class_name => "Related", :as => :related
  
  has_many :related_links, class_name: "Link", as: :content, conditions: "link_type != 'query'"
  has_many :queries, :class_name => "Link", :as => :content, :conditions => { :link_type => "query" }
  
  has_one :content_category, :as => "content"
  has_one :category, :through => :content_category
    
  def self.published
    where(:status => STATUS_LIVE).order("published_at desc")
  end
  
  #----------
  
  def self.content_classes
    self::CONTENT_CLASSES.collect {|k,v| v.constantize }
  end
  
  def self.get_model_for_obj_key(key)
    # convert key from "app/model:id" to AppModel.find(id)
    key =~ /([^:]+):(\d+)/
    
    if $~
      if CONTENT_CLASSES[ $~[1] ]
        return CONTENT_CLASSES[ $~[1] ].constantize
      end
    end
  end
  
  #----------
    
  def self.obj_by_key(key)
    # convert key from "app/model:id" to AppModel.find(id)
    key =~ /([^:]+):(\d+)/
    
    if $~
      if CONTENT_CLASSES[ $~[1] ]
        begin
          return CONTENT_CLASSES[ $~[1] ].constantize.find($~[2])
        rescue
          return nil
        end
      end
    end
    
    return nil
  end
  
  #----------
  
  def self.obj_by_url(url)
    begin
      u = URI.parse(url)
    rescue URI::InvalidURIError
      return nil
    end
    
    key = nil
    CONTENT_MATCHES.detect do |k,v|
      if u.path =~ k
        key = [v,$~[1]].join(":")
      end
    end
    
    puts "key is #{key}"
    
    if key
      # now make sure that content exists
      return self.obj_by_key(key)
    else
      return nil
    end
  end
  
  #----------
    
  def obj_key
    return [self.class::CONTENT_TYPE,self.id].join(":")
  end
  
  #----------
  
  def as_json(*args)
    {
      :id             => self.obj_key,
      :obj_key        => self.obj_key,
      :headline       => self.headline,
      :short_headline => self.short_headline,
      :teaser         => self.teaser,
      :asset          => self.assets.any? ? self.first_asset_square : nil,
      :byline         => render_byline(self,false),
      :published_at   => self.published_at,
      :link_path      => self.link_path,
      :admin_path     => self.admin_path,
      :status         => self.status
    }
  end
  
  #----------
  
  def slideshow?
    if self.class::PRIMARY_ASSET_SCHEME
      return self[ self.class::PRIMARY_ASSET_SCHEME ] == "slideshow" ? true : false
    else
      return false
    end
  end
  
  #----------
  
  def admin_path
    if self.class.const_defined? :ADMIN_PREFIX
      return "/admin/#{self.class::ADMIN_PREFIX}/#{self.id}/"
    else
      self.obj_key() =~ /(\w+)\/(\w+):(\d+)/
      
      if $~
        return "/admin/#{$~[1]}/#{$~[2]}/#{self.id}/"
      else
        return ''
      end
    end
  end
  
  #----------
  
  def remote_link_path
    "http://www.scpr.org#{self.link_path}"
  end
  
  #----------
  
  def sorted_bylines
    authors = [ [],[],[] ]
  
    # 1) break bylines up by role
    self.bylines.each { |b| authors[b.role] << b }

    [0,1,2].each do |i|
      if !authors[i].any?
        next
      end
    
      # 2) now sort each list by last name, first name
      authors[i] = authors[i].sort { |a,b| 
        aN = (a.user ? a.user.name : a.name).split(' ').reverse.join('')
        bN = (b.user ? b.user.name : b.name).split(' ').reverse.join('')

        aN <=> bN
      }
    end
  
    return authors
  end
  
  #----------
  
  def byline_elements
    ["KPCC"]
  end
  
  #----------
  
  def headline
    self[:headline]
  end
  
  #----------

  def short_headline
    self._short_headline? ? self._short_headline : self.headline
  end
  
  #----------
  
  def teaser
    if self._teaser?
      return self._teaser
    end
    
    # -- cut down body to get teaser -- #
    
    l = 180    
    
    # first test if the first paragraph is an acceptable length
    fp = /^(.+)/.match(ActionController::Base.helpers.strip_tags(self.body).gsub("&nbsp;"," ").gsub(/\r/,''))
    
    if fp && fp[1].length < l
      # cool, return this
      return fp[1]
    else
      # try shortening this paragraph
      short = /^(.{#{l}}\w*)\W/.match(fp[1])
      
      if short
        return "#{short[1]}..."
      else
        return fp[1]
      end
    end    
    
  end

  #----------
  
  def first_asset_square
    if self.assets.any?
      self.assets.first.asset.tag(:lsquare)
    end
  end
  
  #----------
    
  def public_datetime
    self.published_at
  end
  
  #----------
  
  def audio
    @audio ||= self._get_audio()
  end
  
  def _get_audio
    # check for ENCO Audio
    audio = []
    
    if self.respond_to?(:enco_audio)
      audio << self.enco_audio
    end
    
    if self.respond_to?(:uploaded_audio)
      audio << self.uploaded_audio
    end
    
    return audio.flatten.compact
  end
end