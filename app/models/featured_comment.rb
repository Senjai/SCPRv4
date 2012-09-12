class FeaturedComment < ActiveRecord::Base
  self.table_name =  'contentbase_featuredcomment'

  has_secretary
  
  administrate do |admin|
    admin.define_list do |list|
      list.order = "published_at desc"
      list.column "bucket"
      list.column "username"
      list.column "excerpt"
      list.column "status"
      list.column "published_at"
    end
  end

  map_content_type_for_django  
  belongs_to :content, polymorphic: true

  scope :published, where(status: ContentBase::STATUS_LIVE).order("published_at desc")
end
