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

  # All ContentBase objects have assets and alarms
  has_many :assets, :class_name => "ContentAsset", :as => :content
  has_many :bylines, :class_name => "ContentByline", :as => :content
    
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
end