class FeaturedComment < ActiveRecord::Base
  self.table_name = 'contentbase_featuredcomment'
  outpost_model
  has_secretary

  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Scopes::PublishedScope
  
  FEATUREABLE_CLASSES = [
    NewsStory,
    BlogEntry,
    ContentShell,
    ShowSegment,
    VideoShell,
    Event
  ]

  #----------------
  # Scopes
  
  #----------------
  # Associations
  belongs_to :content, polymorphic: true, conditions: { status: ContentBase::STATUS_LIVE }
  belongs_to :bucket, class_name: "FeaturedCommentBucket"
  
  #----------------
  # Validation
  validates :username, :status, presence: true
  validates :excerpt, :bucket_id, :content_id, :content_type, presence: true, if: :should_validate?
  
  validate :content_exists?, :content_is_published?

  def needs_validation?
    self.pending? || self.published?
  end
  
  #-----------------

  def content_exists?
    if self.content.nil?
      errors.add(:content_id, "Content doesn't exist. Check the ID.")
    end
  end

  #-----------------

  def content_is_published?
    if self.content && !self.content.published?
      errors.add(:content_id, "Content must be published in order to be featured.")
    end
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
