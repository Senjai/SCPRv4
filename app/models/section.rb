class Section < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Validations::SlugValidation
  include Concern::Callbacks::SphinxIndexCallback

  ROUTE_KEY = "section"

  #----------
  # Scopes
  
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
  # Callbacks
  
  #----------
  # Sphinx  
  define_index do
    indexes title
  end
  
  #----------
  
  def content(options = {})
    options.reverse_merge!(per_page: 10, page: 1)
    
    # Reset to page 1 if the requested page is too high
    # Otherwise an error will occur
    # TODO: Fallback to SQL query instead of just cutting it off.
    if options[:page].to_i > (SPHINX_MAX_MATCHES / options[:per_page].to_i)
      options[:page] = 1 
    end
    
    ContentBase.search({
      :page        => options[:page],
      :per_page    => options[:per_page],
      :with        => { category: self.categories.map { |c| c.id } }
    })
  end

  #----------
  
  def published?
    !self.new_record?
  end
  
  #----------

  def route_hash
    return {} if !self.published? || !self.persisted?
    {
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
end
