class KpccProgram < ActiveRecord::Base
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
  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order    = "title"
      list.per_page = "all"
      
      list.column "title"
      list.column "air_status"
    end
  end
  
  # -------------------
  # Validations
  validates :slug, uniqueness: true
  validates :title, :slug, :air_status, presence: true
  
  # -------------------
  # Associations
  has_many :segments,   foreign_key: "show_id",         class_name: "ShowSegment"
  has_many :episodes,   foreign_key: "show_id",         class_name: "ShowEpisode"
  has_many :schedules,  foreign_key: "kpcc_program_id", class_name: "Schedule"
  belongs_to :missed_it_bucket
  belongs_to :blog
  
  
  # -------------------
  # Scopes
  scope :active,         -> { where(:air_status => ['onair','online']) }
  scope :can_sync_audio, -> { where(air_status: "onair").where("audio_dir is not null").where("audio_dir != ?", "") }
  
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
