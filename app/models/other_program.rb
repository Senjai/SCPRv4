class OtherProgram < ActiveRecord::Base
  self.table_name =  'programs_otherprogram'  
  
  has_many :schedules, :foreign_key => "other_program_id", :class_name => "Schedule"
  
  scope :active, where(:air_status => ['onair','online'])
  
  def display_segments
    false
  end
  
  def display_episodes
    false
  end
  
  #----------
  
  def to_param
    slug
  end
  
  def cache
    view = ActionView::Base.new(ActionController::Base.view_paths, {})  

    class << view  
      include ApplicationHelper
    end
    puts "Attempting to cache feeds for #{self.title}..."
    
    if self.podcast_url?
      begin
        puts "Fetching podcast from #{self.podcast_url}"
        podcast = Feedzirra::Feed.fetch_and_parse self.podcast_url
      rescue
        podcast = nil
      end
      
      if podcast.present? && !podcast.is_a?(Fixnum)
        podcast_html = view.render :partial => "programs/cached/podcast_entry", :collection => podcast.entries.first(5), :as => :entry
        podcast_cache = Rails.cache.write("ext_program:#{self.slug}:podcast", podcast_html)
        puts "Cached Podcast."
      end
    end
    
    if self.rss_url?
      begin
        puts "Fetching podcast from #{self.rss_url}"
        rss = Feedzirra::Feed.fetch_and_parse self.rss_url
      rescue
        rss = nil
      end
      
      if rss.present? && !rss.is_a?(Fixnum)
        rss_cache = Rails.cache.write(
          "ext_program:#{self.slug}:rss", 
           view.render(:partial => "programs/cached/podcast_entry", :collection => rss.entries.first(5), :as => :entry)
        )
        puts "Cached RSS."
      end
    end # rss_url?
    return rss_cache.present? || podcast_cache.present?
  end
end
