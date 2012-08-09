class VideoShell < ContentBase
  self.table_name = "contentbase_videoshell"
  
  CONTENT_TYPE = "content/video"
  CONTENT_TYPE_ID = 125
  ADMIN_PREFIX = "contentbase/videoshell"
  
  acts_as_content
  
  # -------------------
  # Administration
  administrate
  self.list_order = "published_at desc"
  self.list_fields = [
    ['headline'],
    ['slug'],
    ['bylines'],
    ['status'],
    ['published_at']
  ]
  
  # -------------------
  # Validation
  validates_presence_of :headline
    
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