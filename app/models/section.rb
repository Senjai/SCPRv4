class Section < ActiveRecord::Base
  include Model::Validations::SlugValidation
  has_secretary
  
  #----------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.per_page = "all"
      
      list.column "id"
      list.column "title", linked: true
      list.column "slug"
    end
  end

  #----------
  # Association
  has_many    :section_categories
  has_many    :section_blogs
  has_many    :section_promotions
  
  has_many    :categories,      through: :section_categories
  has_many    :blogs,           through: :section_blogs
  has_many    :promotions,      through: :section_promotions
  belongs_to  :missed_it_bucket
  
  #----------
  # Validation
  validates :title, presence: true
  validates :slug, uniqueness: true
  
  #----------
  
  def content(options = {})
    options.reverse_merge!(per_page: 10, page: 1)
    
    # Reset to page 1 if the requested page is too high
    # Otherwise an error will occur
    # TODO: Fallback to SQL query instead of just cutting it off.
    if options[:page].to_i > (SPHINX_MAX_MATCHES / options[:per_page].to_i)
      options[:page] = 1 
    end
    
    ThinkingSphinx.search('',
      classes:    ContentBase.content_classes,
      page:       options[:page],
      per_page:   options[:per_page],
      order:      :published_at,
      sort_mode:  :desc,
      with:       { category: self.categories.map { |c| c.id } },
      retry_stale: true
    )
  end

  #----------
  
  def published?
    !self.new_record?
  end
  
  #----------
  
  def link_path(options={})
    return nil if !published?
    
    Rails.application.routes.url_helpers.section_path(options.merge!({
      slug:           self.slug,
      trailing_slash: true
    }))
  end
  
  def obj_key
    "sections:#{self.id}"
  end
end
