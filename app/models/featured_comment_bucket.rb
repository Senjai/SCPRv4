class FeaturedCommentBucket < ActiveRecord::Base
  self.table_name = 'contentbase_featuredcommentbucket'
  outpost_model
  has_secretary
  
  has_many :comments, class_name: "FeaturedComment", foreign_key: "bucket_id", order: "created_at desc"
  validates :title, presence: true
  
  define_index do
    indexes title, sortable: true
    has created_at
    has updated_at
  end

  class << self
    def select_collection
      FeaturedCommentBucket.order("title").map { |b| [b.title, b.id] }
    end
  end
end
