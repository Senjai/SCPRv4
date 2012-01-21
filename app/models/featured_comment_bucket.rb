class FeaturedCommentBucket < ActiveRecord::Base
  self.table_name =  'contentbase_featuredcommentbucket'
  
  has_many :comments, :class_name => "FeaturedComment", :foreign_key => "bucket_id", :order => "published_at desc"
end