class Podcast < ActiveRecord::Base
  self.table_name = "podcasts_podcast"
  ROUTE_KEY = "podcast"

  ITEM_TYPES = [
    ["Episodes", 'episodes'],
    ["Segments", 'segments'],
    ["Content", 'content']
  ]

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

  has_secretary


  #-------------
  # Association  
  belongs_to :source, polymorphic: true
  belongs_to :category
  
  
  #-------------
  # Validation
  validates :slug, uniqueness: true, presence: true
  validates :title, presence: true
  
  
  #-------------
  # Scopes
  scope :listed, -> { where(:is_listed => true) }


  #-------------

  def content(limit=25)
    @content ||= begin
      content = []
      
      case self.source_type
      when "KpccProgram" || "OtherProgram"
        content = self.source.episodes.published.limit(limit) if self.item_type == "episodes"
        content = self.source.segments.published.limit(limit) if self.item_type == "segments"
      when "Blog"
        content = self.source.entries.published.limit(limit)
      else
        if item_type == "content"
          content = ThinkingSphinx.search('', 
            :with       => { :has_audio => true }, 
            :without    => { :category => '' },
            :classes    => ContentBase.content_classes, 
            :order      => :published_at, 
            :page       => 1, 
            :per_page   => limit, 
            :sort_mode  => :desc,
            retry_stale: true
          ).to_a
        end
      end
      
      content
    end
  end
  
  #-------------
  
  def obj_type
    @obj_type ||= begin
      obj_type = nil
      
      case self.source_type
      when "KpccProgram" || "OtherProgram"
        obj_type = "shows/episode:new" if self.item_type == "episodes"
        obj_type = "shows/segment:new" if self.item_type == "segments"
      when "Blog"
        obj_type = "blogs/entry:new"
      else
        if item_type == "content"
          obj_type = "contentbase:new"
        end
      end
      
      obj_type
    end
  end
  
  #-------------
  
  def route_hash
    {
      :slug => self.slug
    }
  end
end
