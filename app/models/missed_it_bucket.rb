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
  has_many :content, {
    :class_name     => "MissedItContent",
    :foreign_key    => "bucket_id",
    :order          => "position asc",
    :dependent      => :destroy
  }
  
  #--------------------
  # Validation
  validates :title, presence: true

  #--------------------
  # Callbacks

  #--------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes title, sortable: true
  end


  #-------------------
  
  private
  
  def build_content_association(content_hash, content)
    MissedItContent.new(
      :position         => content_hash["position"].to_i,
      :content          => content,
      :missed_it_bucket => self
    )
  end
end
