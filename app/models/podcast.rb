class Podcast < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback

  ROUTE_KEY = "podcast"

  ITEM_TYPES = [
    ["Episodes", 'episodes'],
    ["Segments", 'segments'],
    ["Content", 'content']
  ]

  SOURCES = ["KpccProgram", "OtherProgram", "Blog"]
  
  CONTENT_CLASSES = [
    NewsStory,
    ShowSegment,
    BlogEntry
  ]
  
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
  # Sphinx  
  define_index do
    indexes title, sortable: true
    indexes slug
    indexes description
  end
  
  #-------------
  
  def content(limit=25)
    @content ||= begin
      klasses    = []
      conditions = {}
      
      case self.source_type
      when "KpccProgram"
        conditions.merge!(program: self.source.id)
        klasses.push ShowEpisode if self.item_type == "episodes"
        klasses.push ShowSegment if self.item_type == "segments"
      
      when "OtherProgram"
        # OtherProgram won't actually have any content
        # So, just incase this method gets called,
        # just return an empty array.
        return []
        
      when "Blog"
        conditions.merge!(blog: self.source.id)
        klasses.push BlogEntry

      else
        klasses = [NewsStory, BlogEntry, ShowSegment, ShowEpisode] if item_type == "content"
      end
      
      content_query(limit, klasses, conditions)
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
  
  def content_query(limit, klasses, conditions={})
    ContentBase.search({
      :with    => conditions.reverse_merge({ 
        :has_audio => true
      }), 
      :classes => klasses, 
      :limit   => limit
    })
  end
end
