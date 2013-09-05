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
# We keep the podcast_url attribute on this table (instead of as a related link)
# so that we can more easily validate it, and so we're not tying the behavior
# of this model to an associated model.
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
  validates \
    :title,
    :air_status,
    :source,
    presence: true

  validates :podcast_url, presence: true, url: true
  validates :slug, presence: true, uniqueness: true
  validate :slug_is_unique_in_programs_namespace

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
      :id                 => self.obj_key,
      :source             => self.source,
      :title              => self.title,
      :slug               => self.slug,
      :description        => self.description,
      :host               => self.host,
      :twitter_handle     => self.twitter_handle,
      :air_status         => self.air_status,
      :airtime            => self.airtime,
      :podcast_url        => self.podcast_url,
      :rss_url            => self.get_link('rss'),
      :episodes           => self.external_episodes.order("air_date desc"),
      :segments           => self.external_segments.order("published_at desc"),
      # External Programs are always assumed to have episodes.
      # Maybe this isn't always the case, but this is okay for now.
      :display_episodes   => true
    })
  end


  def published?
    self.air_status != "hidden"
  end


  def importer
    @importer ||= IMPORTERS[self.source].constantize
  end

  def sync
    self.importer.sync(self)
  end


  private

  def slug_is_unique_in_programs_namespace
    if self.slug.present? && KpccProgram.exists?(slug: self.slug)
      self.errors.add(:slug, "must be unique between both " \
                             "KpccProgram and ExternalProgram")
    end
  end
end
