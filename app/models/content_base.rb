class ContentBase < ActiveRecord::Base
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
    'content/shell' => "ContentShell"
  }

  # All ContentBase objects have assets and alarms
  has_many :assets, :class_name => "ContentAsset", :as => :content
  has_many :bylines, :class_name => "ContentByline", :as => :content
  
  has_many :brels, :class_name => "Related", :as => :content
  has_many :frels, :class_name => "Related", :as => :related
  
  has_many :queries, :class_name => "Link", :as => :content, :conditions => { :link_type => "query" }
  
  has_one :content_category, :as => "content"
  has_one :category, :through => :content_category
    
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
        return CONTENT_CLASSES[ $~[1] ].constantize.find($~[2])
      end
    end
    
    return nil
  end
  
  #----------
    
  def obj_key
    return [self.class::CONTENT_TYPE,self.id].join(":")
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
      return "/admin/#{self.class::ADMIN_PREFIX}/#{self.id}"
    else
      self.obj_key() =~ /(\w+)\/(\w+):(\d+)/
      
      if $~
        return "/admin/#{$~[1]}/#{$~[2]}/#{self.id}"
      else
        return ''
      end
    end
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