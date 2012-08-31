class FeaturedComment < ActiveRecord::Base
  self.table_name =  'contentbase_featuredcomment'
  administrate

  map_content_type_for_django  
  belongs_to :content, polymorphic: true

  scope :published, where(status: ContentBase::STATUS_LIVE).order("published_at desc")
end
