class Category < ActiveRecord::Base
  set_table_name 'contentbase_category'

  #has_many :content, :class_name => "ContentCategory", :foreign_key => "category_id", :order => "pub_date desc"
  #has_many :content, :through => :content_categories, :source => :content, :order => "published_at desc"

  #----------

  def content(page=1,per_page=10)
    ThinkingSphinx.search '',
      :classes    => ContentBase.content_classes,
      :page       => page,
      :per_page   => per_page,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => self.id }
  end
  
  #----------

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