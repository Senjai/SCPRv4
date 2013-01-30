class NprStory < ActiveRecord::Base
  include AdminResource::Model::Identifier
  include AdminResource::Model::Naming
  logs_as_task
  
  self.table_name = "npr_npr_story"
  
  # An array of elements in an NPR::Story's 
  # +fullText+ attribute that we want to 
  # strip out before importing.
  UNWANTED_ELEMENTS = [
    '.storytitle',
    '#story-meta',
    '#primaryaudio',
    '.bucketwrap.image'
  ]
  
  #---------------
  # Scopes
  
  #---------------
  # Associations

  #---------------
  # Callbacks

  #---------------
  # Administration
  self.admin = AdminResource::Admin.new(self)
  admin.define_list do
    list_per_page 50
    
    column :headline
    column :published_at
    column :teaser
    column :link, display: :display_npr_link
    column :npr_id, header: "NPR ID"
  end
  
  
  #---------------
  # Sphinx
  define_index do
    indexes :headline
    indexes :teaser
    indexes :link
  end
  
  #---------------

  class << self
    #---------------
    # Since this class isn't getting (and, for the
    # most part, doesn't need) the AdminResource
    # Routing, we'll just manually put this one here.
    def admin_index_path
      @admin_index_path ||= Rails.application.routes.url_helpers.send("admin_#{self.route_key}_path")
    end

    #---------------
    # Sync the cached NPR stories with the NPR API
    def sync_with_api
      # The "id" parameter in this case is actually referencing a list.
      # Stories from the last hour are returned... be sure to run this script
      # more often than that!
      stories = NPR::Story.where(id: [1001], date: (1.hour.ago..Time.now)).set(requiredAssets: 'text').order("date descending").limit(20).to_a
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
          
          if npr_story.save!
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
  end

  #---------------
  
  def async_import
    Resque.enqueue(Job::NprImport, self.id)
  end
  
  #---------------
  # Import this NPR Story.
  #
  # Builds the news story and adds in associations.
  #
  # Returns the created NewsStory, or `false` if the API
  # didn't return anything.
  #
  def import
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
        parse_fullText(npr_story.fullText)
      elsif npr_story.textWithHtml.present?
        npr_story.textWithHtml.to_html
      elsif npr_story.text.present?
        npr_story.text.to_html
      end
    end
    
    #-------------------
    # Build the NewsStory from the API response
    news_story = NewsStory.new(
      :news_agency    => "NPR",
      :source         => "npr",
      :status         => ContentBase::STATUS_DRAFT,
      :headline       => npr_story.title,
      :teaser         => npr_story.teaser,
      :short_headline => npr_story.shortTitle,
      :published_at   => npr_story.pubDate,
      :body           => text
    )
    
    
    #-------------------
    # Add in Bylines
    npr_story.bylines.each do |npr_byline|
      name = npr_byline.name.to_s
      
      if name.present?
        byline = ContentByline.new(name: name)
        news_story.bylines.push byline
      end
    end
    

    #-------------------
    # Add a related link pointing to this story at NPR
    related_link = Link.new(
      :link_type => "website", 
      :title     => "View this story at NPR",
      :link      => npr_story.link_for('html')
    )
    
    news_story.related_links.push related_link
    
    
    #-------------------
    # Add in the primary asset if it exists
    if image = npr_story.primary_image
      assethost = AssetHost::Client.new(auth_token: API_KEYS["assethost"]["token"])
      
      asset = assethost.create(
        :url     => image.src,
        :title   => image.title,
        :caption => image.caption,
        :owner   => [image.producer, image.provider].join("/"),
        :note    => "Imported from NPR: #{npr_story.link_for('html')}"
      )
      
      if asset["id"]
        content_asset = ContentAsset.new(
          :asset_order => 0,
          :asset_id    => asset["id"],
          :caption     => asset["caption"].to_s
        )
        
        news_story.assets << content_asset
      end
    end
    
    #-------------------
    # Save the news story (including all associations),
    # set the NprStory to `:new => false`,
    # and return the NewsStory that was generated.
    news_story.save!
    self.update_attribute(:new, false)
    news_story
  end

  #-------------------
  
  private
  
  def parse_fullText(fullText)
    full_text = Nokogiri::XML::DocumentFragment.parse(fullText)
    
    UNWANTED_ELEMENTS.each do |css|
      full_text.at_css(css).try(:remove)
    end
    
    full_text.to_html
  end
end
