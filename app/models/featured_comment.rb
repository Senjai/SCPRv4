class FeaturedComment < ActiveRecord::Base
  self.table_name = 'contentbase_featuredcomment'
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::HomepageCachingCallback
  include Concern::Methods::PublishingMethods

  STATUS_DRAFT = 0
  STATUS_LIVE  = 5

  STATUS_TEXT = {
    STATUS_DRAFT => "Draft",
    STATUS_LIVE  => "Live"
  }

  FEATUREABLE_CLASSES = [
    "NewsStory",
    "BlogEntry",
    "ContentShell",
    "ShowSegment",
    "Event"
  ]

  #----------------
  # Scopes
  scope :published, -> {
    where(status: STATUS_LIVE)
    .order("created_at desc")
  }

  #----------------
  # Associations
  # FIXME: Remove reference to ContentBase.
  # See HomepageContent for explanation.
  belongs_to :content,
    :polymorphic    => true,
    :conditions     => { status: ContentBase::STATUS_LIVE }

  belongs_to :bucket, class_name: "FeaturedCommentBucket"

  #----------------
  # Validation
  validates \
    :username,
    :status,
    :excerpt,
    :bucket_id,
    :content_type,
    :content_id,
    presence: true

  validate :content_exists?, :content_is_published?

  #-----------------

  def content_exists?
    if self.content.nil?
      errors.add(:content_id, "Content doesn't exist. Check the ID.")
    end
  end

  #-----------------

  def content_is_published?
    if self.content && !self.content.published?
      errors.add(:content_id,
        "Content must be published in order to be featured.")
    end
  end

  #----------------
  # Callbacks

  #----------------
  # Sphinx
  define_index do
    indexes username
    indexes excerpt
  end

  #----------------

  class << self
    def status_select_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end

    def featurable_classes_select_collection
      FEATUREABLE_CLASSES.map { |c| [c.titleize, c] }
    end
  end

  #----------------

  def title
    "Featured Comment (for #{content.obj_key})"
  end


  def published?
    self.status == STATUS_LIVE
  end

  def status_text
    STATUS_TEXT[self.status]
  end
end
