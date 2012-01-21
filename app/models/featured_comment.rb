class FeaturedComment < ActiveRecord::Base
  self.table_name =  'rails_contentbase_featuredcomment'
  
  belongs_to :content, :polymorphic => true
  
  scope :published, where(:status => ContentBase::STATUS_LIVE).order("published_at desc")
  
end