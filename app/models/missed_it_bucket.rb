class MissedItBucket < ActiveRecord::Base
  include Concern::Associations::ContentAssociation
  
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

  #-------------------
  # Fake association getter until we can change
  # `contents` to `content`
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
