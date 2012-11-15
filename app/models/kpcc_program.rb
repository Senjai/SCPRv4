class KpccProgram < ActiveRecord::Base
  include Concern::Validations::SlugValidation
  
  self.table_name = 'programs_kpccprogram'
  ROUTE_KEY       = "program"
  has_secretary
  
  Featured = [
    'take-two',
    'airtalk',
    'offramp'
  ]
  
  PROGRAM_STATUS = {
    "onair"      => "Currently Airing",
    "online"     => "Online Only (Podcast)",
    "archive"    => "No longer available",
    "hidden"     => "Not visible on site"
  }
  
  #-------------------
  # Scopes
  scope :active,         -> { where(:air_status => ['onair','online']) }
  scope :can_sync_audio, -> { where(air_status: "onair").where("audio_dir is not null").where("audio_dir != ?", "") }
  
  #-------------------
  # Associations
  has_many :segments, foreign_key: "show_id", class_name: "ShowSegment"
  has_many :episodes, foreign_key: "show_id", class_name: "ShowEpisode"
  has_many :recurring_schedule_slots, as: :program
  has_many :schedules
  belongs_to :missed_it_bucket
  belongs_to :blog
  
  #-------------------
  # Validations
  validates :title, :air_status, presence: true
  validates :slug, uniqueness: true
  
  #-------------------
  # Callbacks
  
  #-------------------
  # Administration
  administrate do
    define_list do
      list_order "title"
      list_per_page :all
      
      column :title
      column :air_status
    end
  end
  
  #-------------------
  # Sphinx
  define_index do
    indexes title
    indexes description
    indexes host
  end
  
  #-------------------
  
  def published?
    self.air_status != "hidden"
  end
  
  #----------
  
  def absolute_audio_path
    @absolute_audio_path ||= begin
      if self.audio_dir.present?
        File.join(Audio::AUDIO_PATH_ROOT, self.audio_dir)
      end
    end
  end

  #----------
  
  def route_hash
    return {} if !self.persisted? || !self.published?
    {
      :show           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
end
