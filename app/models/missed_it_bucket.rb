class MissedItBucket < ActiveRecord::Base
  self.table_name = "contentbase_misseditbucket"
  has_secretary
  
  #--------------------
  # Scopes
  
  #--------------------
  # Association
  has_many :contents, class_name: "MissedItContent", foreign_key: "bucket_id", order: "position asc"
  
  #--------------------
  # Validation
  validates :title, presence: true

  #--------------------
  # Callbacks
  after_save :expire_cache
  
  #--------------------
  # Administration
  administrate do
    define_list do
      column :id
      column :title
    end
  end
  
  #--------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes title
  end

  #--------------------

  class << self
    def content_key
      "missed_it"
    end
  end

  #--------------------
  
  def expire_cache
    Rails.cache.expire_obj(self.obj_key)
  end
  
  #--------------------
  # TODO Replace this with ContentAssociation
  attr_accessor :content_json
  before_save :parse_content_json
    
  #-------------------

  def parse_content_json
    # If content_json is blank, then that means we
    # didn't make any updates. Return and move on.
    return if self.content_json.blank?
    @_loaded_content = []

    Array(JSON.load(self.content_json)).each do |content_hash|
      if content = ContentBase.obj_by_key(content_hash["id"])
        association = MissedItContent.new(position: content_hash['position'], content: content)
        @_loaded_content.push association
      end
    end

    self.contents = @_loaded_content
    true
  end  
end
