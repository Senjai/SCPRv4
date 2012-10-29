class Podcast < ActiveRecord::Base
  self.table_name = "podcasts_podcast"
  ROUTE_KEY = "podcast"

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

  def content
    @content ||= begin
      case self.item_type
      when "episodes"
        self.program.episodes.published
      when "segments"
        self.program.segments.published
      when "content"
        ThinkingSphinx.search('', 
          :with       => { :has_audio => true }, 
          :without    => { :category => '' },
          :classes    => ContentBase.content_classes, 
          :order      => :published_at, 
          :page       => 1, 
          :per_page   => 15, 
          :sort_mode  => :desc,
          retry_stale: true
        ).to_a
      end
    end
  end
  
  def route_hash
    {
      :slug => self.slug
    }
  end
end
