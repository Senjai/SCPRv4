class VideoShell < ContentBase
  include Model::Validations::ContentValidation
  include Model::Validations::SlugUniqueForPublishedAtValidation

  self.table_name = "contentbase_videoshell"
  
  CONTENT_TYPE = "content/video"
  ADMIN_PREFIX = "contentbase/videoshell"
  
  acts_as_content
  has_secretary
  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order = "published_at desc"
      list.column "headline"
      list.column "slug"
      list.column "bylines"
      list.column "status"
      list.column "published_at"
    end
  end
    
  define_index do
    indexes headline
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "CRC32(CONCAT('content/video:',contentbase_videoshell.id))", :type => :integer, :as => :obj_key
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "0", :as => :is_slideshow, :type => :boolean
    has "0", :as => :has_audio, :type => :boolean
    where "status = #{STATUS_LIVE}"
  end
  
  #--------------------
  
  def link_path(options={})
    Rails.application.routes.url_helpers.video_path(options.merge!({
      id: self.id,
      slug: self.slug,
      trailing_slash: true
    }))
  end
end
