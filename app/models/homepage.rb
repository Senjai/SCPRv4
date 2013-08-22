class Homepage < ActiveRecord::Base
  self.table_name = "layout_homepage"
  outpost_model
  has_secretary

  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::HomepageCachingCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::PublishingMethods


  TEMPLATES = {
    "default"    => "Visual Left",
    "lead_right" => "Visual Right",
    "wide"       => "Large Visual Top"
  }

  TEMPLATE_OPTIONS = TEMPLATES.map { |k, v| [v, k] }


  STATUS_DRAFT    = 0
  STATUS_PENDING  = 3
  STATUS_LIVE     = 5

  STATUS_TEXT = {
    STATUS_DRAFT      => "Draft",
    STATUS_PENDING    => "Pending",
    STATUS_LIVE       => "Live"
  }

  class << self
    def status_select_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end
  end

  #-------------------
  # Scopes

  #-------------------
  # Associations
  has_many :content,
    :class_name   => "HomepageContent",
    :order        => "position",
    :dependent    => :destroy

  accepts_json_input_for :content

  belongs_to :missed_it_bucket

  #-------------------
  # Validations
  validates :base, :status, presence: true

  #-------------------
  # Callbacks
  after_commit :expire_cache

  def expire_cache
    Rails.cache.expire_obj(self)
  end

  #-------------------
  # Sphinx
  define_index do
    indexes base
    has published_at
    has updated_at
  end


  def published?
    self.status == STATUS_LIVE
  end

  def pending?
    self.status == STATUS_PENDING
  end

  def status_text
    STATUS_TEXT[self.status]
  end

  def publish
    self.update_attributes(status: STATUS_LIVE)
  end


  def articles
    @articles ||= self.content.includes(:content).map do |c|
      c.content.to_article
    end
  end


  def scored_content
    # -- Homepage Items -- #

    citems = self.content.collect { |c| c.content || nil }.compact

    # -- Section Blocks -- #

    sections = []

    # run a query for each section
    Category.all.each do |cat|
      # exclude content that is used in our object
      content = ContentBase.search({
        :classes     => [NewsStory, BlogEntry, ContentShell, ShowSegment],
        :limit       => 5,
        :with        => { category: cat.id },
        :without_any => { obj_key: citems.map { |c| c.obj_key.to_crc32 } }
      })

      more     = []
      top      = nil
      sorttime = nil

      content.each do |c|
        # get the content time as Time
        ctime = c.published_at.is_a?(Date) ? c.published_at.to_time : c.published_at

        # if we're still here, weigh this content for sorting
        if !sorttime || ctime > sorttime
          sorttime = ctime
        end

        # does this content have an asset?
        if !top && c.assets.any?
          top = c
          next
        end

        # finally, just drop it in the more bucket
        more << c
      end

      # stick top at the front of content


      # assemble section object
      sec = {
        :section  => cat,
        :content  => [top,more].flatten.compact,
        :sorttime => sorttime
      }


      #----------
      # -- Right Feature Candidates -- #
      #----------

      sec[:candidates] = cat.feature_candidates :exclude => [ citems,top ].flatten.compact
      sec[:right] = sec[:candidates] ? sec[:candidates][0][:content] : nil

      # Add this to our section list
      sections << sec
    end

    # now sort sections by the sorttime
    sections.sort_by! {|s| s[:sorttime] }.reverse!

    sections
  end

  #---------------------


  private

  def build_content_association(content_hash, content)
    if content.published?
      HomepageContent.new(
        :position => content_hash["position"].to_i,
        :content  => content,
        :homepage => self
      )
    end
  end
end
