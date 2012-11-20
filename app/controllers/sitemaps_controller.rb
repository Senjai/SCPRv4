class SitemapsController < ApplicationController
# Information: http://www.sitemaps.org/protocol.html
# Options:
#   @changefreq ||= "daily"
#   @priority ||= "0.5"
# All objects must respond to #remote_link_path

  respond_to :xml
  layout nil
  
  def self.sitemaps
    self.action_methods - ApplicationController.action_methods - %w{index}
  end
  
  def index
    @sitemaps = self.class.sitemaps
  end
  
  def stories
    @changefreq = "hourly"
    @priority   = "1"
    @content    = NewsStory.published.since(30.days.ago)
    render 'sitemap', formats: :xml
  end
  
  def blog_entries
    @changefreq = "hourly"
    @priority   = "0.9"
    @content = BlogEntry.published.since(30.days.ago)
                        
    render 'sitemap', formats: :xml
  end
  
  def episodes
    @changefreq = "daily"
    @priority   = "0.5"
    @content    = ShowEpisode.published.since(30.days.ago)
    render 'sitemap', formats: :xml
  end
  
  def segments
    @changefreq = "hourly"
    @priority   = "0.7"
    @content    = ShowSegment.published.since(30.days.ago)
    render 'sitemap', formats: :xml
  end
  
  
  def queries
    @changefreq = "weekly"
    @priority   = "0.3"
    @content    = PijQuery.visible.since(30.days.ago)
    render 'sitemap', formats: :xml
  end

  def blogs
    @changefreq = "daily"
    @priority   = "0.3"
    @content    = Blog.active.where(is_remote: false).order(:name)
    render 'sitemap', formats: :xml
  end
  
  def programs
    @changefreq = "daily"
    @priority   = "0.3"
    @content    = KpccProgram.active.order(:title) + OtherProgram.active.order(:title)
    render 'sitemap', formats: :xml
  end
  
  def bios
    @changefreq = "daily"
    @priority   = "0.4"
    @content    = Bio.where(is_public: true).order("last_name")
    render 'sitemap', formats: :xml
  end
end
