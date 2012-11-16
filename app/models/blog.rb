class Blog < ActiveRecord::Base
  include Concern::Validations::SlugValidation

  self.table_name = 'blogs_blog'
  has_secretary
  ROUTE_KEY = "blog"
  
  # -------------------
  # Scopes
  scope :active, -> { where(is_active: true) }
  
  # -------------------
  # Associations
  has_many :entries, order: 'published_at desc', class_name: "BlogEntry"
  has_many :tags, through: :entries
  belongs_to :missed_it_bucket
  has_many :authors, through: :blog_authors, order: "position"
  has_many :blog_authors
  has_many :blog_categories
  
  # -------------------
  # Validations
  validates :name, presence: true
  validates :slug, uniqueness: true

  # -------------------
  # Callbacks
  
  # -------------------
  # Administration
  administrate do
    define_list do
      list_order "is_active desc, name"
      list_per_page :all
      
      column :name
      column :slug
      column :teaser,    header: "Tagline"
      column :is_active, header: "Active?"
    end
  end
  
  # ----------------
  # Sphinx
  define_index do
    indexes name
    indexes title
    indexes email
  end
  
  # -------------------
  
  class << self
    def cache_remote_entries
      self.where(is_remote: true).where("feed_url != ?", '').each do |blog|
        feed = Feedzirra::Feed.fetch_and_parse(blog.feed_url)
        # Feedzirra returns the response code as a FixNum if something goes wrong.
        if !feed.is_a?(Fixnum)
          cacher = CacheController.new
          cacher.cache(feed.entries.first, "/blogs/cached/remote_blog_entry", "remote_blog:#{blog.slug}", local: :entry)
        end
      end
    end
  end
  
  # -------------------
  
  def route_hash
    return {} if !self.persisted? or !self.is_active?
    { :blog => self.persisted_record.slug }
  end
end
