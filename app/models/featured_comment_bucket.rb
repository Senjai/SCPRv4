class FeaturedCommentBucket < ActiveRecord::Base
  self.table_name = 'contentbase_featuredcommentbucket'

  administrate
  has_secretary
  
  has_many :comments, :class_name => "FeaturedComment", :foreign_key => "bucket_id", :order => "published_at desc"  
  validates :title, presence: true
end
