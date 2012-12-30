class NprStory < ActiveRecord::Base
  include AdminResource::Model::Identifier
  include AdminResource::Model::Naming
  
  self.table_name = "npr_npr_story"

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
    column :headline
    column :published_at
    column :teaser
    column :link, display: :display_npr_link
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
  end

  #---------------
  
  def async_import
    Resque.enqueue(Job::NprImport, self.id)
  end
  
  #---------------
  # Import this NPR Story.
  #
  # Builds the news story, adds bylines, and adds assets.
  def import
    npr_story = NPR::Story.find_by_id(self.npr_id)
    return false if !npr_story
    
    news_story = NewsStory.new(
      :news_agency    => "NPR",
      :source         => "npr",
      :status         => ContentBase::STATUS_DRAFT,
      :headline       => npr_story.title,
      :teaser         => npr_story.teaser,
      :short_headline => npr_story.shortTitle,
      :published_at   => npr_story.pubDate,
      :body           => npr_story.fullText
    )
    
    # Add in Bylines
    npr_story.bylines.each do |npr_byline|
      byline = ContentByline.new(name: npr_byline.name)
      news_story.bylines.push byline
    end
    
    
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
          :caption     => asset["caption"] || ""
        )
        
        news_story.assets << content_asset
      end
    end
    
    news_story.save!
    self.update_attribute(:new, false)
    news_story
  end
end
