class FeaturedComment < ActiveRecord::Base
  include Model::Methods::StatusMethods
  include Model::Methods::PublishingMethods
  include Model::Callbacks::SetPublishedAtCallback
  include Model::Associations::ContentAlarmAssociation
  include Model::Scopes::PublishedScope
  
  self.table_name = 'contentbase_featuredcomment'
  has_secretary
  
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
  validates :excerpt, :bucket_id, :content_id, :content_type, presence: true, if: -> { self.should_validate? }
  
  def should_validate?
    pending? or published?
  end
  
  #----------------
  # Callbacks
  
  #----------------
  # Administration
  administrate do
    define_list do
      list_order "published_at desc"

      column :bucket
      column :content
      column :username
      column :excerpt
      column :status
      column :published_at
    end
  end
  
  #----------------
  # Sphinx
  define_index do
    indexes username
    indexes excerpt
    indexes content_type
  end
  
  #----------------
  
  def title
    "Featured Comment (for #{content.obj_key})"
  end
end
