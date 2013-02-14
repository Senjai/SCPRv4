class Blog < ActiveRecord::Base
  self.table_name = 'blogs_blog'
  outpost_model
  has_secretary

  include Concern::Validations::SlugValidation

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
  acts_as_searchable
  
  define_index do
    indexes name
    indexes teaser
    has is_active
  end
  
  #-------------------
  
  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    def cache_remote_entries
      cacher = CacheController.new

      self.where(is_remote: true).where("feed_url != ?", '').each do |blog|
        Feedzirra::Feed.safe_fetch_and_parse(blog.feed_url) do |feed|
          cacher.cache(feed.entries.first, "/blogs/cached/remote_blog_entry", "remote_blog:#{blog.slug}", local: :entry)
        end
      end
    end
    
    add_transaction_tracer :cache_remote_entries, category: :task
    
    #-------------------
    # Maps all records to an array of arrays, to be
    # passed into a Rails select helper
    def select_collection
      Blog.order("name").map { |blog| [blog.to_title, blog.id] }
    end
  end
  
  #-------------------
  
  def route_hash
    return {} if !self.persisted? or !self.is_active?
    { :blog => self.persisted_record.slug }
  end
end
