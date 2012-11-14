class Blog < ActiveRecord::Base
  include Model::Validations::SlugValidation

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
  
  def self.cache_remote_entries
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view # So the partial can use the smart_date_js helper
      include ApplicationHelper
    end
    
    success = []
    self.where(is_remote: true).each do |blog|
      if blog.feed_url.present? # No reason to even try if the feed_url is blank
        if feed = Feedzirra::Feed.fetch_and_parse(blog.feed_url) and !feed.is_a?(Fixnum) # Feedzirra returns the response code as a FixNum if something goes wrong.
          success.push blog if Rails.cache.write(
            "remote_blog:#{blog.slug}", 
             view.render(partial: "blogs/cached/remote_blog_entry", collection: feed.entries.first(1), as: :entry)
          )
        end
      end
    end # remote.each
    return success
  end
  
  # -------------------
  
  def route_hash
    return {} if !self.persisted? or !self.is_active?
    { :blog => self.persisted_record.slug }
  end
end
