class FeaturedCommentBucket < ActiveRecord::Base
  administrate
  self.table_name =  'contentbase_featuredcommentbucket'

  has_secretary
  
  has_many :comments, :class_name => "FeaturedComment", :foreign_key => "bucket_id", :order => "published_at desc"
end
