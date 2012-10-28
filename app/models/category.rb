class Category < ActiveRecord::Base
  include Model::Validations::SlugValidation
  
  self.table_name = 'contentbase_category'
  ROUTE_KEY       = "category"
  has_secretary
  administrate do
    define_list do
      list_per_page :all
      
      column :title, linked: true
      column :slug
      column :is_news
      column :comment_bucket
    end
  end
  
  belongs_to :comment_bucket, :class_name => "FeaturedCommentBucket"
  validates :title, presence: true
  
  #----------

  def content(page=1,per_page=10,without_obj=nil)
    ts_max_matches = 1000 # Thinking Sphinx config 'max_matches', throws an error if the offset (from pagination) is higher than this number
    
    if page.to_i*per_page.to_i > ts_max_matches
      return []
    end
    
    args = {
      :classes    => ContentBase.content_classes,
      :page       => page,
      :per_page   => per_page,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => self.id },
      retry_stale: true
    }
    
    if without_obj && without_obj.respond_to?("obj_key")
      args[:without] = { :obj_key => without_obj.obj_key.to_crc32 }
    end
    
    ThinkingSphinx.search('', args)
  end
  
  #----------
  
  def route_hash
    return {} if !self.persisted?
    { category: self.persisted_record.slug }
  end

  #----------
  
  def feature_candidates(args={})
    # lower decay decays more slowly. eg. rate of -0.01 will have a lower score after 3 days than -0.05
    
    candidates = []

    # -- first look for featured comments -- #

    featured = self.comment_bucket.comments.published

    if featured.any?
      # Initial score:  20
      # Decay rate:     0.05
      candidates << {
        :content  => featured.first,
        :score    => 20 * Math.exp( -0.04 * ((Time.now - featured.first.published_at) / 3600) ),
        :metric   => :comment
      }        
    end


    # -- then try to feature videos since they are less common --#
    
    video = ThinkingSphinx.search('',
      :classes      => [VideoShell],
      :page         => 1,
      :per_page     => 1,
      :order        => :published_at,
      :sort_mode    => :desc,
      :with         => { :category => self.id },
      :without_any  => { :obj_key => args[:exclude] ? args[:exclude].collect {|c| c.obj_key.to_crc32 } : [] },
      retry_stale: true
    )
      
    if video.present?
      # Initial score: 15
      # Decay rate: 0.05
      video = video.first
      candidates << {
        :content  => video,
        :score    => (15 * Math.exp( -0.05 * ((Time.now - video.published_at) / 3600) ) ),
        :metric   => :video
      }
    end
    
    
    # -- now try slideshows -- #

    slideshow = ThinkingSphinx.search('',
      :classes    => ContentBase.content_classes,
      :page       => 1,
      :per_page   => 1,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => self.id, :is_slideshow => true },
      :without_any => { :obj_key => args[:exclude] ? args[:exclude].collect {|c| c.obj_key.to_crc32 } : [] },
      retry_stale: true
    )

    if slideshow.any?
      # Initial score:  5 + number of slides
      # Decay rate:     0.01
      slideshow = slideshow.first

      candidates << {
        :content  => slideshow,
        :score    => (5 + slideshow.assets.size) * Math.exp( -0.01 * ((Time.now - slideshow.public_datetime) / 3600) ),
        :metric   => :slideshow
      }
    end

    # -- segment in the last two days? -- #

    segments = ThinkingSphinx.search('',
      :classes    => [ShowSegment],
      :page       => 1,
      :per_page   => 1,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => self.id },
      :without_any => { :obj_key => args[:exclude] ? args[:exclude].collect {|c| c.obj_key.to_crc32 } : [] },
      retry_stale: true
    )

    if segments.any?
      # Initial score:  10
      # Decay rate:     0.02
      seg = segments.first

      candidates << {
        :content  => seg,
        :score    => 10 * Math.exp(-0.02 * ((Time.now - seg.public_datetime) / 3600) ),
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
