class FeaturedComment < ActiveRecord::Base
  include Model::Methods::StatusMethods
  include Model::Methods::PublishingMethods
  include Model::Callbacks::SetPublishedAtCallback
  include Model::Associations::ContentAlarmAssociation
  
  self.table_name = 'contentbase_featuredcomment'

  has_secretary
  
  administrate do |admin|
    admin.define_list do |list|
      list.order = "published_at desc"
      list.column :bucket
      list.column :content
      list.column :username, linked: true
      list.column :excerpt
      list.column :status
      list.column :published_at
    end
  end

  map_content_type_for_django  
  belongs_to :content, polymorphic: true
  belongs_to :bucket, class_name: "FeaturedCommentBucket"
  
  scope :published, where(status: ContentBase::STATUS_LIVE).order("published_at desc")
  
  validates :username, :excerpt, :bucket_id, :content_id, :content_type, presence: true
  
  # Override AdminResource's `to_title`
  def to_title
    "Featured Comment ##{self.id} (for #{content.simple_title})"
  end
end
