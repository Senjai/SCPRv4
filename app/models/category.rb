class Category < ActiveRecord::Base
  self.table_name =  'contentbase_category'

  #has_many :content, :class_name => "ContentCategory", :foreign_key => "category_id", :order => "pub_date desc"
  #has_many :content, :through => :content_categories, :source => :content, :order => "published_at desc"
  
  belongs_to :comment_bucket, :class_name => "FeaturedCommentBucket"

  #----------

  def content(page=1,per_page=10,without_obj=nil)
    args = {
      :classes    => ContentBase.content_classes,
      :page       => page,
      :per_page   => per_page,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => self.id }      
    }
    
    if without_obj && without_obj.respond_to?("obj_key")
      args[:without] = { :obj_key => without_obj.obj_key.to_crc32 }
    end
    
    ThinkingSphinx.search '', args
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