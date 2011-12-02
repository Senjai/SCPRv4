class Category < ActiveRecord::Base
  set_table_name 'news_category'
  
  has_many :story_categories, :foreign_key => 'category_id', :conditions => { :is_primary => true }
  has_many :stories, :through => :story_categories, :order => "published_at desc"

end