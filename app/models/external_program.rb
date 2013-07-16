class ExternalProgram < ActiveRecord::Base
  outpost_model
  has_secretary

  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  include Concern::Validations::SlugValidation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Callbacks::SphinxIndexCallback

  ROUTE_KEY = "program"

  # "source" => "Importer module name"
  IMPORTERS = [
    "npr-api" => "NprProgramImporter",
    "rss"     => "RssImporter"
  ]


  #-------------------
  # Scopes
  scope :active, -> { where(air_status: ['onair', 'online']) }


  #-------------------
  # Associations
  has_many :recurring_schedule_rules, as: :program, dependent: :destroy
  has_many :external_episodes, dependent: :destroy
  has_many :external_segments


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
    indexes description
    indexes host
    indexes organization
  end

  #-------------------

  class << self
    def select_collection
      ExternalProgram.order("title").map { |p| [p.to_title, p.id] }
    end
  end

  #----------

  def published?
    self.air_status != "hidden"
  end

  #----------

  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :show           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end


  def sync
    self.importer_type.constantize.sync(self)
  end
end
