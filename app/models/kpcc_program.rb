class KpccProgram < ActiveRecord::Base
  self.table_name =  'programs_kpccprogram'
  
  ConnectDefaults = {
    facebook: "http://www.facebook.com/kpccfm",
    twitter: "kpcc",
    rss: "",
    podcast: ""
  }
  
  Featured = [
    'madeleine-brand',
    'patt-morrison',
    'offramp',
    'airtalk'
  ]
  
  has_many :segments, foreign_key: "show_id", class_name: "ShowSegment"
  has_many :episodes, :foreign_key => "show_id", :class_name => "ShowEpisode"
  has_many :schedules, :foreign_key => "kpcc_program_id", :class_name => "Schedule"
  belongs_to :blog
  
  scope :active, where(:air_status => ['onair','online'])
  
  def to_param
    slug
  end

  def facebook_url # So we don't have to worry about a fallback in the views.
    self[:facebook_url].blank? ? ConnectDefaults[:facebook] : self[:facebook_url]
  end
  
  def twitter_url # So we don't have to worry about a fallback in the views.
    self[:twitter_url].blank? ? ConnectDefaults[:twitter] : self[:twitter_url]
  end
  
  def twitter_absolute_url
    if twitter_url =~ /twitter\.com/
      twitter_url
    else
      "http://twitter.com/#{twitter_url}"
    end
  end
  
  # Validation for later
  # validates :slug, uniqueness: true

end