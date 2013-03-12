class MissedItBucket < ActiveRecord::Base
  self.table_name = "contentbase_misseditbucket"
  outpost_model
  has_secretary

  include Concern::Associations::ContentAssociation
  include Concern::Callbacks::TouchCallback
  
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
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes title, sortable: true
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

  #-------------------
  # Fake association accessor until we can change
  # `contents` to `content` (after mercer)
  def content
    self.contents
  end

  def content=(val)
    self.contents = val
  end
  
  #-------------------
  
  private
  
  # Override this from ContentAssociation until 
  # we can change the association name from `contents` 
  # to `content`
  def build_content_association(content_hash, content)
    MissedItContent.new(
      :position         => content_hash["position"].to_i,
      :content          => content,
      :missed_it_bucket => self
    )
  end
end
