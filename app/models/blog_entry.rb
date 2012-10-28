class BlogEntry < ContentBase
  include Model::Methods::StatusMethods
  include Model::Methods::PublishingMethods
  include Model::Validations::ContentValidation
  include Model::Validations::SlugUniqueForPublishedAtValidation
  include Model::Callbacks::SetPublishedAtCallback
  include Model::Associations::ContentAlarmAssociation
  include Model::Associations::AudioAssociation
  include Model::Associations::AssetAssociation
  include Model::Scopes::SinceScope
  
  self.table_name = "blogs_entry"
  acts_as_content has_format: true
  has_secretary
  
  PRIMARY_ASSET_SCHEME = :blog_asset_scheme
  ROUTE_KEY = "blog_entry"
    
  # ------------------
  # Administration
  administrate do
    define_list do
      list_order "published_at desc"
      
      column "headline"
      column "blog"
      column "bylines"
      column "status"
      column "published_at"
    end
  end


  # ------------------
  # Validation
  validates_presence_of :blog
  
  def should_validate?
    pending? or published?
  end
  
  
  # ------------------
  # Association
  belongs_to :blog

  has_many :tagged, class_name: "TaggedContent", as: :content
  has_many :tags, through: :tagged, dependent: :destroy
  
  has_many :blog_entry_blog_categories, foreign_key: 'entry_id'
  has_many :blog_categories, through: :blog_entry_blog_categories, dependent: :destroy
  
  
  # ------------------
  # Scopes
  

  # ------------------
  
  define_index do
    indexes headline
    indexes body
    has blog.id,          as: :blog
    has category.id,      as: :category
    has category.is_news, as: :category_is_news
    has published_at
    has "1", as: :is_source_kpcc, type: :boolean
    has "CRC32(CONCAT('blogs/entry:',#{BlogEntry.table_name}.id))",     type: :integer, as: :obj_key
    has "(#{BlogEntry.table_name}.blog_asset_scheme <=> 'slideshow')",  type: :boolean, as: :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0",       type: :boolean, as: :has_audio
    where "#{BlogEntry.table_name}.status = #{STATUS_LIVE} and #{Blog.table_name}.is_active = 1"
    join audio
  end
    
  #----------
  
  def byline_elements
    []
  end
  
  def disqus_identifier
    if dsq_thread_id.present? && wp_id.present?
      "#{wp_id} http://multiamerican.scpr.org/?p=#{wp_id}"
    else
      super
    end
  end
  
  def disqus_shortname
    if dsq_thread_id.present? && wp_id.present?
      'scprmultiamerican'
    else
      super
    end
  end
  
  def previous
    self.class.published.where("published_at < ? and blog_id = ?", self.published_at, self.blog_id).first
  end

  def next
    self.class.published.where("published_at > ? and blog_id = ?", self.published_at, self.blog_id).first
  end
  
  #----------
  
  def extended_teaser(*args)
    target    = args[0] || 800
    more_text = args[1] || "Read More..."
    
    content         = Nokogiri::HTML::DocumentFragment.parse(self.body)
    extended_teaser = Nokogiri::HTML::DocumentFragment.parse(nil)
    
    content.children.each do |child|
      break if extended_teaser.content.length >= target
      extended_teaser.add_child child
    end
    
    extended_teaser.add_child "<p><a href=\"#{self.link_path}\">#{more_text}</a></p>"
    return extended_teaser.to_html
  end
  
  #----------

  def route_hash
    return {} if !self.persisted? or !self.published?
    {
      :blog           => self.persisted_record.blog.slug,
      :year           => self.persisted_record.published_at_was.year, 
      :month          => "%02d" % self.persisted_record.published_at_was.month,
      :day            => "%02d" % self.persisted_record.published_at_was.day,
      :id             => self.persisted_record.id,
      :slug           => self.persisted_record.slug_was,
      :trailing_slash => true
    }
  end
end
