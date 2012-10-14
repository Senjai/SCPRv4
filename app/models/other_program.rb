class OtherProgram < ActiveRecord::Base
  self.table_name =  'programs_otherprogram'  
  has_secretary

  ROUTE_KEY = "program"

  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order = "title"
      list.per_page   = "all"
      
      list.column "title"
      list.column "produced_by"
      list.column "air_status"
    end
  end

  # -------------------
  # Associations
  has_many :schedules
  

  # -------------------
  # Validations
  validates :title, :slug, :air_status, presence: true
  validate :rss_or_podcast_present
    
  def rss_or_podcast_present
    if self.podcast_url.blank? && self.rss_url.blank?
      errors.add(:base, "Must specify either a Podcast url or an RSS url")
      errors.add(:podcast_url, "")
      errors.add(:rss_url, "")
    end
  end
  
  
  # -------------------
  # Scopes
  scope :active, where(:air_status => ['onair','online'])
  
  
  def display_segments
    false
  end
  
  def display_episodes
    false
  end

  #----------
  
  def published?
    self.air_status != "hidden"
  end
  
  #----------
  
  def route_hash
    return {} if !self.persisted? || !self.published?
    {
      :show           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
  
  #----------
  
  def cache
    view = ActionView::Base.new(ActionController::Base.view_paths, {})  

    class << view  
      include ApplicationHelper
    end
    
    if self.podcast_url?
      begin
        podcast = Feedzirra::Feed.fetch_and_parse self.podcast_url
      rescue
        podcast = nil
      end
      
      if podcast.present? && !podcast.is_a?(Fixnum)
        podcast_html = view.render :partial => "programs/cached/podcast_entry", :collection => podcast.entries.first(5), :as => :entry
        Rails.cache.write("ext_program:#{self.slug}:podcast", podcast_html)
      end
    end
    
    if self.rss_url?
      begin
        rss = Feedzirra::Feed.fetch_and_parse self.rss_url
      rescue
        rss = nil
      end
      
      if rss.present? && !rss.is_a?(Fixnum)
        Rails.cache.write(
          "ext_program:#{self.slug}:rss", 
           view.render(:partial => "programs/cached/podcast_entry", :collection => rss.entries.first(5), :as => :entry)
        )
      end
    end # rss_url?
    return podcast.present? || rss.present?
  end
end
