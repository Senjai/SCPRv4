class NewsStory < ContentBase
  include Model::Methods::PublishingMethods
  include Model::Validations::ContentValidation
  include Model::Validations::SlugUniqueForPublishedAtValidation
  include Model::Callbacks::SetPublishedAtCallback
  include Model::Associations::ContentAlarmAssociation
  include Model::Associations::AudioAssociation
  include Model::Associations::AssetAssociation
  include Model::Scopes::SinceScope
  
  
  self.table_name = 'news_story'
  acts_as_content
  has_secretary
  
  PRIMARY_ASSET_SCHEME = :story_asset_scheme
  ROUTE_KEY = "news_story"
  
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
  
  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order = "published_at desc"
      list.column "headline"
      list.column "slug"
      list.column "news_agency"
      list.column "audio"
      list.column "status"
      list.column "published_at"
    end
  end


  # ------------------
  # Validation
  def should_validate?
    pending? or published?
  end
  
  
  # -------------------
  # Scopes

  
  # -------------------
  
  define_index do
    indexes headline
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "(news_story.source <=> 'kpcc')", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('news/story:',news_story.id))", :type => :integer, :as => :obj_key
    has "(news_story.story_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", :as => :has_audio, :type => :boolean
    where "status = #{STATUS_LIVE}"
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
  
  def byline_elements
    bylines = []
        
    if self.news_agency
      bylines << self.news_agency
    end
  end
  
end
