class FeaturedComment < ActiveRecord::Base
  self.table_name =  'contentbase_featuredcomment'
  map_content_type_for_django

  administrate
  
  belongs_to :content, :polymorphic => true

  scope :published, where(:status => ContentBase::STATUS_LIVE).order("published_at desc")
end
