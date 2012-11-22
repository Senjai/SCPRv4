class BlogEntry < ActiveRecord::Base
  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AudioAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Associations::RelatedContentAssociation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Validations::ContentValidation
  include Concern::Validations::SlugUniqueForPublishedAtValidation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::CommentMethods
  include Concern::Methods::HeadlineMethods
  include Concern::Methods::TeaserMethods
  
  self.table_name = "blogs_entry"
  has_secretary
  
  PRIMARY_ASSET_SCHEME = :blog_asset_scheme
  ROUTE_KEY = "blog_entry"

  #------------------
  # Scopes
  
  #------------------
  # Association
  belongs_to :blog
  
  has_many :tagged, class_name: "TaggedContent", as: :content
  has_many :tags, through: :tagged, dependent: :destroy
  
  has_many :blog_entry_blog_categories, foreign_key: 'entry_id'
  has_many :blog_categories, through: :blog_entry_blog_categories, dependent: :destroy
  
  #------------------
  # Validation
  validates_presence_of :blog
  
  def should_validate?
    pending? or published?
  end
  
  #------------------
  # Callbacks
  
  #------------------
  # Administration
  administrate do
    define_list do
      column :headline
      column :blog
      column :bylines
      column :status
      column :published_at
    end
  end
  include Concern::Methods::ContentJsonMethods
  
  
  #------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes body
    has blog.id,          as: :blog
    has category.id,      as: :category
    has category.is_news, as: :category_is_news
    has published_at
    has status
    has blog.is_active, as: :findable, type: :boolean
    has "1", as: :is_source_kpcc, type: :boolean
    has "CRC32(CONCAT('blogs/entry:',#{BlogEntry.table_name}.id))", type: :integer, as: :obj_key
    has "(#{BlogEntry.table_name}.blog_asset_scheme <=> 'slideshow')", type: :boolean, as: :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", type: :boolean, as: :has_audio
    join audio
  end
  
  #---------------------
  
  def byline_elements
    []
  end
  
  #-------------------
  # Need to work around multi-american until we can figure
  # out how to merge those comments in with kpcc
  def disqus_identifier
    if dsq_thread_id.present? && wp_id.present?
      "#{wp_id} http://multiamerican.scpr.org/?p=#{wp_id}"
    else
      super
    end
  end

  #-------------------
  
  def disqus_shortname
    if dsq_thread_id.present? && wp_id.present?
      'scprmultiamerican'
    else
      super
    end
  end

  #-------------------
  
  def previous
    self.class.published.where("published_at < ? and blog_id = ?", self.published_at, self.blog_id).first
  end

  #-------------------

  def next
    self.class.published.where("published_at > ? and blog_id = ?", self.published_at, self.blog_id).first
  end
  
  #-------------------
  
  def extended_teaser(*args)
    target      = args[0] || 800
    more_text   = args[1] || "Read More..."
    break_class = "story-break"
    
    content         = Nokogiri::HTML::DocumentFragment.parse(self.body)
    extended_teaser = Nokogiri::HTML::DocumentFragment.parse(nil)
    
    content.children.each do |child|
      break if (child.attributes["class"].to_s == break_class) || (extended_teaser.content.length >= target)
      extended_teaser.add_child child
    end
    
    extended_teaser.add_child "<p><a href=\"#{self.link_path}\">#{more_text}</a></p>"
    return extended_teaser.to_html
  end
  
  #-------------------

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
