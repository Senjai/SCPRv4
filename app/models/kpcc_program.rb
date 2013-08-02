class KpccProgram < ActiveRecord::Base
  self.table_name = 'programs_kpccprogram'
  outpost_model
  has_secretary

  include Concern::Validations::SlugValidation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Callbacks::SphinxIndexCallback

  mount_uploader :image, ImageUploader

  ROUTE_KEY = "program"

  PROGRAM_STATUS = {
    "onair"      => "Currently Airing",
    "online"     => "Online Only (Podcast)",
    "archive"    => "No longer available",
    "hidden"     => "Not visible on site"
  }

  AIR_STATUS = PROGRAM_STATUS.map { |k, v| [v, k] }

  #-------------------
  # Scopes
  scope :active,         -> { where(air_status: ['onair','online']) }
  scope :can_sync_audio, -> {
    where(air_status: "onair")
    .where("audio_dir is not null")
    .where("audio_dir != ?", "")
  }

  #-------------------
  # Associations
  has_many :segments, foreign_key: "show_id", class_name: "ShowSegment"
  has_many :episodes, foreign_key: "show_id", class_name: "ShowEpisode"
  has_many :recurring_schedule_rules, as: :program, dependent: :destroy
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
  define_index do
    indexes title, sortable: true
    indexes airtime
    indexes description
    indexes host
  end

  #-------------------

  class << self
    def select_collection
      KpccProgram.order("title").map { |p| [p.to_title, p.id] }
    end
  end

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
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :show           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end


  def to_program
    @to_program ||= Program.new({
      :original_object    => self,
      :source             => 'kpcc',
      :title              => self.title,
      :slug               => self.slug,
      :description        => self.description,
      :host               => self.host,
      :twitter_handle     => self.twitter_handle,
      :air_status         => self.air_status,
      :airtime            => self.airtime,
      :podcast_url        => self.get_link('podcast'),
      :rss_url            => self.get_link('rss'),
      :public_url         => self.public_url,
      :episodes           => self.episodes.published
    })
  end


  def podcast_url
    self.get_link("podcast")
  end

  def rss_url
    self.get_link("rss")
  end
end
