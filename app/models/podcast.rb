class Podcast < ActiveRecord::Base
  has_secretary
  
  ROUTE_KEY = "podcast"

  ITEM_TYPES = [
    ["Episodes", 'episodes'],
    ["Segments", 'segments'],
    ["Content", 'content']
  ]

  SOURCES = ["KpccProgram", "OtherProgram", "Blog"]
  
  #-------------
  # Scopes
  
  #-------------
  # Association  
  belongs_to :source, polymorphic: true
  belongs_to :category
  
  #-------------
  # Validation
  validates :slug, uniqueness: true, presence: true
  validates :title, :url, :podcast_url, presence: true
  
  #-------------
  # Callbacks
  
  #-------------
  # Administration
  administrate do
    define_list do
      column :title
      column :slug
      column :source
      column :podcast_url
      column :keywords
      column :is_listed
    end
  end
  
  #-------------
  # Sphinx
  define_index do
    indexes title
    indexes slug
    indexes description
  end
  
  #-------------
  
  def content(limit=25)
    @content ||= begin
      klasses    = []
      conditions = {}
      
      case self.source_type
      when "KpccProgram" || "OtherProgram"
        conditions.merge!(program: self.source.id)
        klasses.push ShowEpisode if self.item_type == "episodes"
        klasses.push ShowSegment if self.item_type == "segments"

      when "Blog"
        conditions.merge!(blog: self.source.id)
        klasses.push BlogEntry

      else
        klasses = ContentBase.content_classes if item_type == "content"
      end
      
      search(limit, klasses, conditions)
    end
  end
  
  #-------------
  
  def route_hash
    {
      :slug => self.slug
    }
  end

  #-------------
  
  private
  
  def search(limit, klasses, conditions={})
    ThinkingSphinx.search('',
      :with        => { has_audio: true }.merge!(conditions), 
      :classes     => klasses, 
      :order       => :published_at, 
      :page        => 1, 
      :per_page    => limit, 
      :sort_mode   => :desc,
      :retry_stale => true
    )
  end
end
