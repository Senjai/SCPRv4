class BlogEntry < ContentBase
  self.table_name =  "blogs_entry"
  
  # MULTI-AMERICAN
  attr_accessor :postmeta, :categories
  # END
  
  # -- Administration -- #
  administrate!
  self.list_order = "published_at desc"
  self.list_fields = [
    ['id'],
    ['headline', link: true],
    ['blog'],
    ['bylines'],
    ['status'],
    ['published_at']
  ] 

  # -- Validations -- #
  validates_presence_of :title, :slug, :blog_id, :short_headline
  
  # -- Associations -- #
  belongs_to :blog
  belongs_to :author, :class_name => "Bio"
  has_many :tagged, :class_name => "TaggedContent", :as => :content
  has_many :tags, :through => :tagged  
  
  # -- Scopes -- #
  default_scope includes(:bylines)
  scope :this_week, lambda { where("published_at > ?", Date.today - 7) }

  CONTENT_TYPE = "blogs/entry"
  PRIMARY_ASSET_SCHEME = :blog_asset_scheme
  
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
  
  def link_path(options={})
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