class ContentBase < ActiveRecord::Base
  include ApplicationHelper
  self.abstract_class = true
  
  STATUS_KILLED   = -1
  STATUS_DRAFT    = 0
  STATUS_REWORK   = 1
  STATUS_EDIT     = 2
  STATUS_PENDING  = 3
  STATUS_LIVE     = 5
  
  STATUS_TEXT = {
      STATUS_KILLED   => "Killed",
      STATUS_DRAFT    => "Draft",
      STATUS_REWORK   => "Awaiting Rework",
      STATUS_EDIT     => "Awaiting Edits",
      STATUS_PENDING  => "Pending",
      STATUS_LIVE     => "Published"
  }
  
  CONTENT_CLASSES = {
    content: {
      'news/story'    => "NewsStory",
      'shows/segment' => "ShowSegment",
      'shows/episode' => "ShowEpisode",
      'blogs/entry'   => "BlogEntry",
      'content/video' => "VideoShell",
      'content/shell' => "ContentShell"
    },
    other: {
      'pij/query'     => "PijQuery",
      'events/event'  => "Event"
    }
  }
  
  ALL_CLASSES = CONTENT_CLASSES[:content].merge CONTENT_CLASSES[:other]
      
  CONTENT_MATCHES = {
    %r{^/news/\d+/\d\d/\d\d/(\d+)/.*}                => 'news/story',
    %r{^/admin/news/story/(\d+)/}                    => 'news/story',
    %r{^/blogs/[-_\w]+/\d+/\d\d/\d\d/(\d+)/.*}       => 'blogs/entry',
    %r{^/admin/blogs/entry/(\d+)/}                   => 'blogs/entry',
    %r{^/programs/[\w_-]+/\d{4}/\d\d/\d\d/(\d+)/.*}  => 'shows/segment',
    %r{^/admin/shows/segment/(\d+)/}                 => 'shows/segment',
    %r{^/admin/shows/episode/(\d+)/}                 => 'shows/episode',
    %r{^/admin/contentbase/contentshell/(\d+)/}      => 'content/shell',
    %r{^/video/(\d+)/.*}                             => 'content/video',
    %r{^/admin/contentbase/videoshell/(\d+)/}        => 'content/video'
  }

  STORY_SCHEMES = [
    ["Float Right (default)", ""],
    ["Wide", "wide"],
    ["Slideshow", "slideshow"]
  ]

  STORY_EXTRA_SCHEMES = [
    ["Hide (default)", ""],
    ["Sidebar Display", "sidebar"]
  ]

  LEAD_SCHEMES = [
    ["Default", ""],
    ["Wide", "wide"]
  ]

  BLOG_SCHEMES = [
    ["Full Width (default)", ""],
    ["Float Right", "right"],
    ["Slideshow", "slideshow"]
  ]
    
  # All ContentBase objects have assets and one alarm
  has_many :bylines,          as: :content, class_name: "ContentByline",  dependent: :destroy
    
  has_many :brels,            as: :content, class_name: "Related"
  has_many :frels,            as: :related, class_name: "Related"
  
  has_many :related_links,    as: :content, class_name: "Link",           conditions: "link_type != 'query'"
  has_many :queries,          as: :content, class_name: "Link",           conditions: { link_type: "query" }
  
  has_one :content_category,  as: :content  
  has_one :category,          through: :content_category
  
  #--------------------

  class << self
    def published
      where(status: STATUS_LIVE).order("published_at desc")
    end
  
    #--------------------
  
    def content_classes
      self::CONTENT_CLASSES[:content].collect {|k,v| v.constantize }
    end
  
    def other_classes
      self::CONTENT_CLASSES[:other].collect {|k,v| v.constantize }
    end
  
    def all_classes
      self.content_classes + self.other_classes
    end

    #--------------------
    # Wrapper around ThinkingSphinx to just query all
    # ContentBase classes.
    def search(*args)
      options = args.extract_options!
      query   = args[0].to_s
      
      defaut_attributes = { status: ContentBase::STATUS_LIVE.to_s, findable: "1" }
      
      options.reverse_merge!({
        :classes     => ContentBase.content_classes,
        :page        => 1,
        :order       => :published_at,
        :sort_mode   => :desc,
        :retry_stale => true,
        :populate    => true
      })
      
      if options[:with].present?
        options[:with].reverse_merge! default_attributes
      else
        options[:with] = default_attributes
      end
      
      begin
        ThinkingSphinx.search(query, options)
      rescue Riddle::ConnectionError, ThinkingSphinx::SphinxError
        Kaminari.paginate_array([])
      end
    end
    #--------------------
    # Cut down body to get teaser
    def generate_teaser(text, length=180)
      stripped_body = ActionController::Base.helpers.strip_tags(text).gsub("&nbsp;"," ").gsub(/\r/,'')
      match = stripped_body.match(/^(.+)/)

      if !match
        return ""
      else
        first = match[1]
        if first.length < length
          return first
        else
          # try shortening this paragraph
          short = first.match /^(.{#{length}}\w*)\W/
          return short ? "#{short[1]}..." : first
        end
      end
    end

    #--------------------
  
    def get_model_for_obj_key(key)
      # convert key from "app/model:id" to AppModel
      key =~ /([^:]+):(\d+)/
    
      if $~
        if ALL_CLASSES[ $~[1] ]
          return ALL_CLASSES[ $~[1] ].constantize
        end
      end
    end
  
    #--------------------
    
    def obj_by_key(key)
      # convert key from "app/model:id" to AppModel.find(id)
      key =~ /([^:]+):(\d+)/
    
      if $~
        if ALL_CLASSES[ $~[1] ]
          begin
            return ALL_CLASSES[ $~[1] ].constantize.find($~[2])
          rescue
            return nil
          end
        end
      end
    
      return nil
    end
  
    #--------------------
  
    def obj_by_url(url)
      begin
        u = URI.parse(url)
      rescue URI::InvalidURIError
        return nil
      end
    
      key = nil
      CONTENT_MATCHES.detect do |k,v|
        if u.path =~ k
          key = [v,$~[1]].join(":")
        end
      end
    
      if key
        # now make sure that content exists
        return self.obj_by_key(key)
      else
        return nil
      end
    end
  
  
    #--------------------
  
    def status_text_collect
      ContentBase::STATUS_TEXT.map { |p| [p[1], p[0]] }
    end
  end
  
  #--------------------
  
  def json
    {
      :id             => self.obj_key,
      :headline       => self.headline,
      :short_headline => self.short_headline,
      :teaser         => self.teaser,
      :asset          => self.assets.present? ? self.assets.first.asset.lsquare.tag : nil,
      :byline         => render_byline(self,false),
      :published_at   => self.published_at,
      :status         => self.status,
      :admin_path     => self.django_edit_url
    }
  end


  #----------
  
  def sorted_bylines
    authors = [ [],[],[] ]
  
    # 1) break bylines up by role
    self.bylines.each { |b| authors[b.role] << b }

    [0,1,2].each do |i|
      if !authors[i].any?
        next
      end
    
      # 2) now sort each list by last name, first name
      authors[i] = authors[i].sort { |a,b| 
        aN = (a.user ? a.user.name : a.name).split(' ').reverse.join('')
        bN = (b.user ? b.user.name : b.name).split(' ').reverse.join('')

        aN <=> bN
      }
    end
  
    return authors
  end
  
  #----------
  
  # Takes one or more finders for relations and returns one list 
  # sorted by public_datetime desc and with duplicates removed
  def sorted_relations(*lists)
    content = []
    lists.each do |finder|
      # push whichever piece of content isn't us onto the content array
      content << finder.all.collect { |rel| rel.content == self ? rel.related : rel.content }
    end
    
    # flatten and remove duplicates
    content = content.flatten.compact.uniq
    
    # sort the list and return it
    return content.sort_by { |c| c.public_datetime }.reverse
  end
  
  #----------
  
  def byline_elements
    ["KPCC"]
  end
  
  #----------
    
  def public_datetime
    self.published_at
  end
end
