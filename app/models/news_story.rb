class NewsStory < ActiveRecord::Base
  outpost_model
  
  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AudioAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Associations::RelatedContentAssociation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Associations::HomepageContentAssociation
  include Concern::Associations::FeaturedCommentAssociation
  include Concern::Associations::MissedItContentAssociation
  include Concern::Validations::ContentValidation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::GenerateShortHeadlineCallback
  include Concern::Callbacks::GenerateTeaserCallback
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::HomepageCachingCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::StatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::CommentMethods

  self.table_name = 'news_story'
  has_secretary
  ROUTE_KEY = "news_story"
  
  SOURCES = [
    ['KPCC',                        'kpcc'],
    ['KPCC & wires',                'kpcc_plus_wire'],
    ['AP',                          'ap'],
    ['KPCC wire services',          'kpcc_wire'],
    ['NPR',                         'npr'],
    ['NPR & wire services',         'npr_wire'],
    ['New America Media',           'new_america'],
    ['NPR & KPCC',                  'npr_kpcc'],
    ['Center for Health Reporting', 'chr']
  ]
  
  ASSET_SCHEMES = [
    ["Float Right (default)", ""],
    ["Wide", "wide"],
    ["Slideshow", "slideshow"],
    ["Video", "video"],
    ["No Display", "hidden"]
  ]
  
  EXTRA_ASSET_SCHEMES = [
    ["Hide (default)", ""],
    ["Sidebar Display", "sidebar"]
  ]
  
  #-------------------
  # Scopes

  #-------------------
  # Association
  
  #------------------
  # Validation
  def needs_validation?
    self.pending? || self.published?
  end
  
  #------------------
  # Callbacks

  #-------------------
  # Sphinx  
  define_index do
    indexes headline
    indexes body
    indexes bylines.user.name, as: :bylines
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has updated_at
    has status
    has "1", as: :findable, type: :boolean
    has "(#{NewsStory.table_name}.source <=> 'kpcc')", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('news/story:',#{NewsStory.table_name}.id))", :type => :integer, :as => :obj_key
    has "(#{NewsStory.table_name}.story_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", :as => :has_audio, :type => :boolean
    join audio
  end
    
  #----------

  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :year           => self.persisted_record.published_at.year, 
      :month          => "%02d" % self.persisted_record.published_at.month, 
      :day            => "%02d" % self.persisted_record.published_at.day, 
      :id             => self.persisted_record.id,
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
      
  #----------
  
  def byline_extras
    Array(self.news_agency)
  end

  #-------------------

  def to_article
    @to_article ||= Article.new({
      :original_object    => self,
      :id                 => self.obj_key,
      :title              => self.headline,
      :short_title        => self.short_headline,
      :public_datetime    => self.published_at,
      :teaser             => self.teaser,
      :body               => self.body,
      :assets             => self.assets,
      :audio              => self.audio,
      :attributions       => self.bylines,
      :byline             => self.byline,
      :permalink          => self.remote_link_path
    })
  end

  #-------------------

  def to_abstract
    @to_abstract ||= Abstract.new({
      :original_object        => self,
      :headline               => self.short_headline,
      :summary                => self.teaser,
      :source                 => "KPCC",
      :url                    => self.remote_link_path,
      :assets                 => self.assets,
      :category               => self.category,
      :article_published_at   => self.published_at
    })
  end

end
