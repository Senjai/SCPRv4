class Homepage < ActiveRecord::Base
  set_table_name "layout_homepage"
  
  has_many :content, :class_name => "HomepageContent", :order => "position asc"
  
  scope :published, where(:status => ContentBase::STATUS_LIVE).order("published_at desc")
  
end