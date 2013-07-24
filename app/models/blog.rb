class Blog < ActiveRecord::Base
  self.table_name = 'blogs_blog'
  outpost_model
  has_secretary

  include Concern::Validations::SlugValidation
  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Associations::RelatedLinksAssociation

  ROUTE_KEY = "blog"

  #-------------------
  # Scopes
  scope :active, -> { where(is_active: true) }

  #-------------------
  # Associations
  has_many :entries, order: 'published_at desc', class_name: "BlogEntry"
  belongs_to :missed_it_bucket
  has_many :authors, through: :blog_authors
  has_many :blog_authors

  #-------------------
  # Validations
  validates :name, presence: true
  validates :slug, uniqueness: true
  validates :description, presence: true

  #-------------------
  # Callbacks

  #----------------
  # Sphinx
  define_index do
    indexes name
    indexes teaser
    has is_active
  end

  #-------------------

  class << self
    #-------------------
    # Maps all records to an array of arrays, to be
    # passed into a Rails select helper
    def select_collection
      Blog.order("name").map { |blog| [blog.to_title, blog.id] }
    end
  end

  #-------------------

  def route_hash
    return {} if !self.persisted? || !self.persisted_record.is_active?
    { :blog => self.persisted_record.slug }
  end
end
