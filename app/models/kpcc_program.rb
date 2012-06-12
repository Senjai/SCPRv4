class KpccProgram < ActiveRecord::Base
  self.table_name =  'programs_kpccprogram'
  
  # Validation for later
  # validates :slug, uniqueness: true
  
  ConnectDefaults = {
    facebook: "http://www.facebook.com/kpccfm",
    twitter: "kpcc",
    rss: "http://wwww.scpr.org/feeds/all_news",
    podcast: ""
  }
  
  Featured = [
    'madeleine-brand',
    'airtalk',
    'patt-morrison',
    'offramp'
  ]
  
  has_many :segments, foreign_key: "show_id", class_name: "ShowSegment"
  has_many :episodes, :foreign_key => "show_id", :class_name => "ShowEpisode"
  has_many :schedules, :foreign_key => "kpcc_program_id", :class_name => "Schedule"
  belongs_to :missed_it_bucket
  belongs_to :blog
  
  scope :active, where(:air_status => ['onair','online'])
  
  def to_param
    slug
  end

  # TODO Rename these fallback helpers
  def facebook_url # So we don't have to worry about a fallback in the views.
    self[:facebook_url].blank? ? ConnectDefaults[:facebook] : self[:facebook_url]
  end
  
  def twitter_url # So we don't have to worry about a fallback in the views.
    self[:twitter_url].blank? ? ConnectDefaults[:twitter] : self[:twitter_url]
  end
  
  def rss_url
    self[:rss_url].blank? ? ConnectDefaults[:rss] : self[:rss_url]
  end
  
  
  def twitter_absolute_url
    if twitter_url =~ /twitter\.com/
      twitter_url
    else
      "http://twitter.com/#{twitter_url}"
    end
  end
  
  #----------
  
  def link_path
    Rails.application.routes.url_helpers.program_path(self,:trailing_slash => true)
  end
  
  def remote_link_path
    "http://www.scpr.org#{self.link_path}"
  end
  
  #----------

end