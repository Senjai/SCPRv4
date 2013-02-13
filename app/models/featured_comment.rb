class FeaturedComment < ActiveRecord::Base
  self.table_name = 'contentbase_featuredcomment'
  outpost_model
  has_secretary

  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Scopes::PublishedScope
  
  #----------------
  # Scopes
  
  #----------------
  # Associations
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  belongs_to :bucket, class_name: "FeaturedCommentBucket"
  
  #----------------
  # Validation
  validates :username, :status, presence: true
  validates :excerpt, :bucket_id, :content_id, :content_type, presence: true, if: :should_validate?
  
  def needs_validation?
    self.pending? || self.published?
  end
  
  #----------------
  # Callbacks

  #----------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes username
    indexes excerpt
    has published_at
  end
  
  #----------------
  
  def title
    "Featured Comment (for #{content.obj_key})"
  end
end
