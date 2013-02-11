class KpccProgram < ActiveRecord::Base
  self.table_name = 'programs_kpccprogram'
  outpost_model
  has_secretary

  include Concern::Validations::SlugValidation
  include Concern::Associations::RelatedLinksAssociation
  
  ROUTE_KEY = "program"
  
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
  
  AIR_STATUS = PROGRAM_STATUS.map { |k, v| [v, k] }
  
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
  # Sphinx
  acts_as_searchable
  
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
