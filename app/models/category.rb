class Category < ActiveRecord::Base
  set_table_name 'contentbase_category'
  
  #has_many :story_categories, :foreign_key => 'category_id' #, :conditions => { :is_primary => true }
  #has_many :stories, :through => :story_categories, :order => "published_at desc"

  has_many :content, :class_name => "ContentCategory", :foreign_key => "category_id", :order => "pub_date desc"
  #has_many :content, :through => :content_categories, :source => :content, :order => "published_at desc"

  def link_path
    if self.is_news
      Rails.application.routes.url_helpers.news_section_path(
        :category => self.slug,
        :trailing_slash => true
      )
    else
      Rails.application.routes.url_helpers.arts_section_path(
        :category => self.slug,
        :trailing_slash => true
      )      
    end
  end
end