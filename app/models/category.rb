class Category < ActiveRecord::Base
  self.table_name = 'contentbase_category'
  outpost_model
  has_secretary

  include Concern::Validations::SlugValidation
  include Concern::Callbacks::SphinxIndexCallback
  
  ROUTE_KEY = 'root_slug'
  
  #-------------------
  # Scopes
  
  #-------------------
  # Associations
  belongs_to :comment_bucket, class_name: "FeaturedCommentBucket"
  
  #-------------------
  # Validations
  validates :title, presence: true
  
  #-------------------
  # Callbacks

  #-------------------
  # Sphinx  
  define_index do
    indexes title, sortable: true
    indexes slug, sortable: true
    has is_news
  end
  
  #----------

  def route_hash
    return {} if !self.persisted?
    { path: self.persisted_record.slug }
  end

  #----------

  def content(page=1,per_page=10,without_obj=nil)
    if (page.to_i * per_page.to_i > SPHINX_MAX_MATCHES) || page.to_i < 1
      page = 1
    end
    
    args = {
      :page     => page,
      :per_page => per_page,
      :with     => { category: self.id }
    }
    
    if without_obj && without_obj.respond_to?("obj_key")
      args[:without] = { obj_key: without_obj.obj_key.to_crc32 }
    end
    
    ContentBase.search(args)
  end
  
  #----------
  
  def feature_candidates(args={})
    # lower decay decays more slowly. eg. rate of -0.01 will have a lower score after 3 days than -0.05
    
    candidates = []

    # -- first look for featured comments -- #

    featured = self.comment_bucket.comments.published.first

    if featured.present?
      # Initial score:  20
      # Decay rate:     0.05
      candidates << {
        :content  => featured,
        :score    => 20 * Math.exp( -0.04 * ((Time.now - featured.created_at) / 3600) ),
        :metric   => :comment
      }
    end
    
    
    # -- now try slideshows -- #

    slideshow = ContentBase.search({
      :limit       => 1,
      :with        => { category: self.id, is_slideshow: true },
      :without_any => { obj_key: args[:exclude] ? args[:exclude].collect {|c| c.obj_key.to_crc32 } : [] }
    })

    if slideshow.any?
      # Initial score:  5 + number of slides
      # Decay rate:     0.01
      slideshow = slideshow.first

      candidates << {
        :content  => slideshow,
        :score    => (5 + slideshow.assets.size) * Math.exp( -0.01 * ((Time.now - slideshow.published_at) / 3600) ),
        :metric   => :slideshow
      }
    end

    # -- segment in the last two days? -- #

    segments = ContentBase.search({
      :classes     => [ShowSegment],
      :limit       => 1,
      :with        => { :category => self.id },
      :without_any => { obj_key: args[:exclude] ? args[:exclude].collect {|c| c.obj_key.to_crc32 } : [] }
    })

    if segments.any?
      # Initial score:  10
      # Decay rate:     0.02
      seg = segments.first

      candidates << {
        :content  => seg,
        :score    => 10 * Math.exp(-0.02 * ((Time.now - seg.published_at) / 3600) ),
        :metric   => :segment
      }
    end

    if candidates.any?
      return candidates.sort_by! {|c| -c[:score] }
    else
      return nil
    end
  end
end
