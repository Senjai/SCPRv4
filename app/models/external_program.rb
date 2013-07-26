# ExternalProgram is a Program that comes from an outside source,
# such as an API or an RSS feed.
#
# To add an importer:
#
# 1. Write your importer. Place it in the `app/importers` directory.
#    It only needs to respond to the `sync` class method, which accepts
#    the program as its only argument.
#    This method should fetch the segments (in an RSS feed these would be the
#    entries) and save them to our database. But it can do whatever you want.
#    I'm not here to tell you what to do.
# 2. Add it to the IMPORTERS hash. The key is the arbitrary text ID for the 
#    importer, and the value is the class name.
# 3. Set the program to use that importer in the CMS.
# 4. There's not a 4th step, get to work already.
#
class ExternalProgram < ActiveRecord::Base
  outpost_model
  has_secretary

  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  include Concern::Validations::SlugValidation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Callbacks::SphinxIndexCallback

  ROUTE_KEY = "program"

  # "source" => "Importer module name"
  IMPORTERS = {
    "npr-api" => "NprProgramImporter",
    "rss"     => "RssProgramImporter"
  }

  FEED_TYPES = {
    "rss-episodes" => "RSS entries are full episodes",
    "rss-segments" => "RSS entries are segments"
  }


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
  validates :title, :air_status, :slug, :source, presence: true
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

    def sync
      self.active.each(&:sync)
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

  def importer
    @importer ||= IMPORTERS[self.source].constantize
  end

  def feed_url
    self.podcast_url.present? ? self.podcast_url : self.rss_url
  end

  def sync
    self.importer.sync(self)
  end
end
