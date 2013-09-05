class MissedItBucket < ActiveRecord::Base
  self.table_name = "contentbase_misseditbucket"
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::TouchCallback

  #--------------------
  # Scopes

  #--------------------
  # Association
  has_many :content, {
    :class_name     => "MissedItContent",
    :foreign_key    => "bucket_id",
    :order          => "position asc",
    :dependent      => :destroy
  }

  accepts_json_input_for :content

  #--------------------
  # Validation
  validates :title, :slug, presence: true

  #--------------------
  # Callbacks
  before_validation :generate_slug, if: -> { self.slug.blank? }
  after_commit :expire_cache

  def expire_cache
    Rails.cache.expire_obj(self)
  end


  #--------------------
  # Sphinx  
  define_index do
    indexes title, sortable: true
  end


  def articles(limit=nil)
    @articles ||= self.content.includes(:content).limit(limit).map do |c|
      c.content.to_article
    end
  end


  private

  def generate_slug
    if self.title.present?
      self.slug = self.title.parameterize[0...50].sub(/-+\z/, "")
    end
  end

  def build_content_association(content_hash, content)
    if content.published?
      MissedItContent.new(
        :position         => content_hash["position"].to_i,
        :content          => content,
        :missed_it_bucket => self
      )
    end
  end
end
