class BlogEntry < ContentBase
  self.table_name =  "blogs_entry"
  CONTENT_TYPE = "blogs/entry"
  CONTENT_TYPE_ID = 44
  PRIMARY_ASSET_SCHEME = :blog_asset_scheme
    
  # ------------------
  # Administration
  administrate
  self.list_order = "published_at desc"
  self.list_fields = [
    ['id'],
    ['headline', link: true],
    ['blog'],
    ['bylines'],
    ['status'],
    ['published_at']
  ] 

  # ------------------
  # Validation
  validates_presence_of :title, :slug, :blog_id, :short_headline
  
  # ------------------
  # Association
  belongs_to :blog
  belongs_to :author, :class_name => "Bio"

  has_many :tagged, :class_name => "TaggedContent", :as => :content
  has_many :tags, :through => :tagged, dependent: :destroy
  
  has_many :blog_entry_blog_categories, foreign_key: 'entry_id'
  has_many :blog_categories, through: :blog_entry_blog_categories, dependent: :destroy
  
  # ------------------
  # Scopification
  default_scope includes(:bylines)
  scope :this_week, lambda { where("published_at > ?", Date.today - 7) }
  
  define_index do
    indexes title
    indexes content
    has blog.id, :as => :blog
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('blogs/entry:',blogs_entry.id))", :type => :integer, :as => :obj_key
    has "(blogs_entry.blog_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", :as => :has_audio, :type => :boolean
    where "blogs_entry.status = #{STATUS_LIVE} and blogs_blog.is_active = 1"
    join audio
  end
    
  #----------
  
  def byline_elements
    []
  end
  
  def has_format?
    true
  end
  
  def disqus_identifier
    if dsq_thread_id.present? && wp_id.present?
      "#{wp_id} http://multiamerican.scpr.org/?p=#{wp_id}"
    else
      obj_key
    end
  end
  
  def disqus_shortname
    if dsq_thread_id.present? && wp_id.present?
      'scprmultiamerican'
    else
      super
    end
  end
    
  def headline
    self.title
  end
  
  def body
    self.content
  end
    
  def previous
    self.class.published.first(:conditions => ["published_at < ? and blog_id = ?", self.published_at, self.blog_id], :limit => 1, :order => "published_at desc")
  end

  def next
    self.class.published.first(:conditions => ["published_at > ? and blog_id = ?", self.published_at, self.blog_id], :limit => 1, :order => "published_at asc")
  end
  
  #----------
  
  def remote_link_path
    if self.wp_id.present?
      self.link_path
    else
      super
    end
  end
  
  def link_path(options={})
    # Temporary workaround for MA until we flip the switch
    if self.wp_id.present?
      "http://multiamerican.scpr.org/#{self.published_at.year}/#{"%02d" % self.published_at.month}/#{self.slug}"
    else
      Rails.application.routes.url_helpers.blog_entry_path(options.merge!({
        :blog => self.blog.slug,
        :year => self.published_at.year, 
        :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
        :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
        :id => self.id,
        :slug => self.slug,
        :trailing_slash => true
      }))
    end
  end
end