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
    #'news/story'    => NewsStory,
    #'shows/segment' => ShowSegment,
    #'shows/episode' => ShowEpisode,
    #'blogs/entry'   => BlogEntry
  }

  # All ContentBase objects have assets and alarms
  has_many :assets, :class_name => "ContentAsset", :as => :content
  has_many :bylines, :class_name => "ContentByline", :as => :content
  
  has_many :brels, :class_name => "Related", :as => :content
  has_many :frels, :class_name => "Related", :as => :related
  
  has_many :queries, :class_name => "Link", :as => :content, :conditions => { :link_type => "query" }
    
  #----------
    
  def self.obj_by_key(key)
    # convert key from "app/model:id" to AppModel.find(id)
    key =~ /([^:]+):(\d+)/
    
    if $~
      if CONTENT_CLASSES[ $~[1] ]
        return CONTENT_CLASSES[ $~[1] ].find($~[2])
      end
    end
    
    return nil
  end
  
  #----------
    
  def obj_key
    return [self.class::CONTENT_TYPE,self.id].join(":")
  end

  #----------
  
  def byline_elements
    ["KPCC"]
  end
  
  #----------
    
  def public_datetime
    self.published_at
  end
  
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