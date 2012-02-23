class VideoShell < ContentBase
  self.table_name = "contentbase_videoshell"
  CONTENT_TYPE = "content/video"
  CONTENT_TYPE_ID = 125
  ADMIN_PREFIX = "contentbase/videoshell"
  
  # Validations for the future
  validates :headline, presence: true
  validates :body, presence: true
  
  scope :published, where(status: STATUS_LIVE)
  scope :recent_first, order("published_at desc")
  
  define_index do
    indexes headline
    indexes _teaser
    has "null", :as => :category, :type => :integer
    has "0", :as => :category_is_news, :type => :boolean
    has published_at, :as => :published_at
    has "CRC32(CONCAT('content/video:',contentbase_contentvideo.id))", :type => :integer, :as => :obj_key
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "0", :as => :is_slideshow, :type => :boolean
    where "status = #{STATUS_LIVE}"
  end
  
  def link_path # OPTIMIZE Dry this method up across ContentBase subclasses
    Rails.application.routes.url_helpers.video_path(self, trailing_slash: true)
  end
end