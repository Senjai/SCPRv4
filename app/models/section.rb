class Section < ActiveRecord::Base
  #----------
  # Administration
  administrate
  self.list_fields = [
    ["id"],
    ["title", link: true],
    ["slug"]
  ]
  
  #----------
  # Association
  has_many :section_categories
  has_many :section_blogs
  has_many :section_promotions
  has_many :categories, through: :section_categories
  has_many :blogs,      through: :section_blogs
  has_many :promotions, through: :section_promotions
  
  #----------
  # Validation
  validates_presence_of :title, :slug
  
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
end
