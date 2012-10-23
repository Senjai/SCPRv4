class Bio < ActiveRecord::Base
  include Model::Validations::SlugValidation
  
  ROUTE_KEY       = "bio"
  self.table_name = 'bios_bio'
  has_secretary

  #--------------
  # Associations
  belongs_to  :user,    class_name: "AdminUser"
  has_many    :bylines, class_name: "ContentByline",  foreign_key: :user_id

  
  #--------------
  # Scopes    
  scope :visible, where(is_public: true)

  
  #--------------
  # Validation
  validates :slug, uniqueness: true
  validates :name, presence: true
  validates :last_name, presence: true
  
  #--------------
  # Administration
  administrate do
    define_list do
      list_order "last_name"
      list_per_page :all
      
      column :name
      column :email
      column :is_public, header: "Show on Site?"
    end
  end

  
  #--------------
  # Callbacks
  before_validation :set_last_name, if: -> { self.last_name.blank? }
  def set_last_name
    if self.name.present?
      self.last_name = self.name.split(" ").last
    end
  end

    
  #----------
  
  def indexed_bylines(page=1, per_page=15)
    # Sphinx max_matches limits how much it can offset results, so for Bios with a lot
    # of pages of Bylines, we have to fallback to an actual SQL query if the offset is
    # too high. Run some Ruby methods on the byines to mimic SQL's order and conditions.
    if page.to_i > (SPHINX_MAX_MATCHES / per_page.to_i)
      bylines = self.bylines.includes(:content).all
                    
      bylines.select  { |b| b.content.published? }
             .sort_by { |b| b.content.published_at }
             .reverse
             .paginate(page: page, per_page: per_page)
    else
      ContentByline.search('', 
        order:      :published_at,
        sort_mode:  :desc,
        with:       { user_id: self.id, status: ContentBase::STATUS_LIVE },
        per_page:   per_page,
        page:       page
      )
    end
  end
  
  #---------------------
  
  def twitter_url
    if twitter.present?
      "http://twitter.com/#{twitter.gsub(/@/, '')}"
    end
  end
  
  #---------------------
  
  def headshot
    if self.asset_id?
      @_asset ||= Asset.find(self.asset_id)
    else
      return nil
    end
  end
  
  #---------------------
  
  def json
    { asset: self.headshot }
  end
  
  #---------------------

  def route_hash
    return {} if !self.persisted? || !self.is_public
    { slug: self.persisted_record.slug }
  end
end
