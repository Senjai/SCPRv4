class NewsStory < ContentBase
  self.table_name =  'news_story'
  acts_as_content
  
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
  
  # -------------------
  # Callbacks  
  before_save :fill_fields, on: :create
  def fill_fields
    self.published_at = Time.now unless published_at
  end
  
  # -------------------
  # Validations
  validates :headline,  presence: true
  validates :body,      presence: true
  validates :slug,      presence: true, format: { with: /^[a-zA-Z0-9\-_]+$/, message: "not correctly formatted. 0-9, a-z, A-Z, -, _" }

  # -------------------
  # Scopes
  scope :this_week, lambda { where("published_at > ?", Date.today - 7) }
  
  CONTENT_TYPE = 'news/story'
  
  PRIMARY_ASSET_SCHEME = :story_asset_scheme
  
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
      
  def link_path(options={})
    Rails.application.routes.url_helpers.news_story_path(options.merge!({
      :year => self.published_at.year.to_s, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :id => self.id,
      :slug => self.slug,
      :trailing_slash => true
    }))
  end
  
  #----------
  
  def byline_elements
    bylines = []
        
    if self.news_agency
      bylines << self.news_agency
    end
  end
  
end