class NprStory < ActiveRecord::Base
  self.table_name = "npr_npr_story"

  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  include Outpost::Model::Identifier
  include Outpost::Model::Naming
  logs_as_task
  
  # An array of elements in an NPR::Story's 
  # +fullText+ attribute that we want to 
  # strip out before importing.
  UNWANTED_CSS = [
    '.storytitle',
    '#story-meta',
    '.bucketwrap',
    '#primaryaudio',
    'object'
  ]
  
  UNWANTED_ATTRIBUTES = [
    'class',
    'id',
    'data-metrics'
  ]

  # NPR IDs we're importing:
  # Reference: http://www.npr.org/api/inputReference.php  
  IMPORT_IDS = [
    '1001',      # News (topic)
    '93559255',  # Planet Money (blog)
    '93568166',  # Monkey See (blog)
    '15709577',  # All Songs Considered (blog)
    '173754155'  # Code Switch (blog)
  ]
  

  #---------------
  # Scopes
  
  #---------------
  # Associations

  #---------------
  # Callbacks
  
  #---------------
  # Sphinx
  define_index do
    indexes headline
    indexes teaser
    indexes link

    has published_at
  end
  
  #---------------

  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    #---------------
    # Since this class isn't getting (and, for the
    # most part, doesn't need) the Outpost
    # Routing, we'll just manually put this one here.
    def admin_index_path
      @admin_index_path ||= Rails.application.routes.url_helpers.send("outpost_#{self.route_key}_path")
    end
    
    #---------------
    # Utility method for parsing an NPR Story's fullText
    def parse_fullText(fullText)
      full_text = Nokogiri::XML::DocumentFragment.parse(fullText)

      UNWANTED_CSS.each do |css|
        full_text.css(css).remove
      end

      UNWANTED_ATTRIBUTES.each do |attribute|
        full_text.xpath(".//@#{attribute}").remove
      end

      full_text.to_html
    end
    
    #---------------
    # Queue an API sync
    def async_sync_with_api
      Resque.enqueue(Job::NprFetch)
    end
    
    #---------------
    # Sync the cached NPR stories with the NPR API
    def sync_with_api
      # The "id" parameter in this case is actually referencing a list.
      # Stories from the last hour are returned... be sure to run this script
      # more often than that!
      # 
      stories = NPR::Story.where(id: IMPORT_IDS, date: (1.hour.ago..Time.now)).set(requiredAssets: 'text').order("date descending").limit(20).to_a
      log "#{stories.size} stories found from the past hour (max 20)"
      
      added = []
      stories.each do |story|
        # Check if this story was already cached - if not, cache it.
        if NprStory.find_by_npr_id(story.id)
          log "NPR Story ##{story.id} already cached"
        else
          npr_story = NprStory.new(
            :npr_id       => story.id, 
            :headline     => story.title, 
            :teaser       => story.teaser,
            :published_at => story.pubDate,
            :link         => story.link_for("html"),
            :new          => true
          )
          
          if npr_story.save
            added.push npr_story
            log "Saved NPR Story ##{story.id} as NprStory ##{npr_story.id}"
          else
            log "Couldn't save NPR Story ##{story.id}"
          end
        end
      end # each
      
      # Return which stories were actually cached
      added
    end

    add_transaction_tracer :sync_with_api, category: :task
  end

  #---------------

  def as_json(*args)
    super.merge({
      "id"         => self.obj_key, 
      "obj_key"    => self.obj_key,
      "to_title"   => self.to_title,
    })
  end
  
  #---------------
  
  def async_import(options={})
    import_to_class = options[:import_to_class]
    Resque.enqueue(Job::NprImport, self.id, import_to_class)
  end
  
  #---------------
  # Import this NPR Story.
  #
  # Builds the news story and adds in associations.
  #
  # Returns the created NewsStory, or `false` if the API
  # didn't return anything.
  #
  def import(options={})
    import_to_class = options[:import_to_class] || "NewsStory"

    npr_story = NPR::Story.find_by_id(self.npr_id)
    return false if !npr_story
    
    # Make sure some text gets imported... 
    # if not then this whole process is useless.
    #
    # 1. If the +fullText+ exists, use it 
    #
    # 2. If the +fullText+ is blank, then try +textWithHtml+.
    # 
    # 3. If still nothing, then try just +text+.
    # 
    # 4. Failing all of that, we'll still import the story, 
    # but the body will just be blank.
    #
    text = begin
      if npr_story.fullText.present?
        NprStory.parse_fullText(npr_story.fullText)
      elsif npr_story.textWithHtml.present?
        npr_story.textWithHtml.to_html
      elsif npr_story.text.present?
        npr_story.text.to_html
      end
    end
    
    #-------------------
    # Build the NewsStory from the API response
    article = import_to_class.constantize.new(
      :status         => ContentBase::STATUS_DRAFT,
      :headline       => npr_story.title,
      :teaser         => npr_story.teaser,
      :short_headline => npr_story.shortTitle.present? ? npr_story.shortTitle : npr_story.title,
      :body           => text
    )
    
    if article.is_a? NewsStory
      article.news_agency   = "NPR",
      article.source        = "npr"
    end
    
    #-------------------
    # Add in Bylines
    npr_story.bylines.each do |npr_byline|
      name = npr_byline.name.to_s
      
      if name.present?
        byline = ContentByline.new(name: name)
        article.bylines.push byline
      end
    end
    

    #-------------------
    # Add a related link pointing to this story at NPR
    related_link = RelatedLink.new(
      :link_type => "website", 
      :title     => "View this story at NPR",
      :url      => npr_story.link_for('html')
    )
    
    article.related_links.push related_link
    
    
    #-------------------
    # Add in the primary asset if it exists
    if image = npr_story.primary_image
      asset = AssetHost::Asset.create(
        :url     => image.src,
        :title   => image.title,
        :caption => image.caption,
        :owner   => [image.producer, image.provider].join("/"),
        :note    => "Imported from NPR: #{npr_story.link_for('html')}"
      )
      
      if asset["id"]
        content_asset = ContentAsset.new(
          :position   => 0,
          :asset_id   => asset["id"],
          :caption    => asset["caption"].to_s
        )
        
        article.assets << content_asset
      end
    end
    
    
    #-------------------
    # Save the news story (including all associations),
    # set the NprStory to `:new => false`,
    # and return the NewsStory that was generated.
    article.save!
    self.update_attribute(:new, false)
    article
  end

  add_transaction_tracer :import, category: :task
end
