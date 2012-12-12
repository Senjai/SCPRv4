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
  
  def import
    npr_story = NPR::Story.find(self.npr_id)
    
    news_story = NewsStory.new(
      :headline       => npr_story.title,
      :teaser         => npr_story.teaser,
      :short_headline => npr_story.shortTitle,
      :slug           => npr_story.slug,
      :published_at   => npr_story.pubDate
    )
    
    # Add in the primary asset if it exists
    if image = npr_story.primary_image
      assethost_client = AssetHost::Client.new(auth_token: API_KEYS["assethost"]["token"])
      assethost.create(
        :hidden  => true,
        :url     => image.src,
        :title   => image.title,
        :caption => image.caption,
        :owner   => "#{image.producer}/#{image.provider['__content__']}",
        :note    => "Imported from NPR: #{npr_story.link.first['__content__']}"
      )
    end    
  end
end
