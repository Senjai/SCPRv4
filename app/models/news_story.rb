class NewsStory < ActiveRecord::Base
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
  
  self.table_name = 'news_story'
  has_secretary
  
  PRIMARY_ASSET_SCHEME = :story_asset_scheme
  ROUTE_KEY            = "news_story"
  
  LOCALES = [ 
    ["CA/Local",  "local"],
    ["U.S.",      "natnl"],
    ["World",     "world"]
  ]
  
  SOURCES = [
    ['KPCC',                'kpcc'],
    ['KPCC & wires',        'kpcc_plus_wire'],
    ['AP',                  'ap'],
    ['KPCC wire services',  'kpcc_wire'],
    ['NPR',                 'npr'],
    ['NPR & wire services', 'npr_wire'],
    ['New America Media',   'new_america'],
    ['NPR & KPCC',          'npr_kpcc']
  ]
  
  #-------------------
  # Scopes
  
  #-------------------
  # Association
  
  #------------------
  # Validation
  def should_validate?
    pending? or published?
  end
  
  #------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      column :headline
      column :slug
      column :news_agency
      column :audio
      column :status
      column :published_at
    end
  end
  include Concern::Methods::ContentJsonMethods
  

  #-------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has status
    has "1", as: :findable, type: :boolean
    has "(news_story.source <=> 'kpcc')", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('news/story:',news_story.id))", :type => :integer, :as => :obj_key
    has "(news_story.story_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", :as => :has_audio, :type => :boolean
    join audio
  end
    
  #----------

  def route_hash
    return {} if !self.persisted? || !self.published?
    {
      :year           => self.persisted_record.published_at.year.to_s, 
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
end
