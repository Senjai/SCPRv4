module ChrArticleImporter
  extend LogsAsTask::ClassMethods

  SOURCE = "chr"

  API_ROOT      = "https://www.publish2.com/organizations/2198"
  API_LIST_PATH = "custom_views/1010/content.nprml"


  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    def sync
      # We can't use NPR::Story since it wants to use your
      # configured NPR API URL. Instead, we'll go one level
      # below that and use NPR::API::Client directly, and then copy
      # the behavior of NPR::Story.find
      client = NPR::API::Client.new(url: API_ROOT)
      response = client.query(
        :path         => API_LIST_PATH,
        :apiKey       => "", # Don't send our NPR API key to Publish2
        :output       => "", # Publish2 uses the "format" param instead
        :format       => 'json',
        :user         => Rails.application.config.api['publish2']['user'],
        :pass         => Rails.application.config.api['publish2']['pass'],
        :limit        => 20
      )

      return false if !response.list

      npr_stories = Array.wrap(response.list.stories)

      log "#{npr_stories.size} CHR stories found from the past hour"

      added = []

      npr_stories.reject { |s|
        RemoteArticle.exists?(source: SOURCE, article_id: s.id)
      }.each do |npr_story|

        cached_article = RemoteArticle.new(
          :source       => SOURCE,
          :article_id   => npr_story.id,
          :headline     => npr_story.title,
          :teaser       => npr_story.teaser,
          :published_at => npr_story.pubDate,
          :url          => npr_story.link_for("html"),
          :is_new       => true
        )

        if cached_article.save
          added.push cached_article
          log "Saved CHR article ##{npr_story.id} as RemoteArticle ##{cached_article.id}"
        else
          log "Couldn't save CHR Story ##{npr_story.id}"
        end
      end # each

      added
    end


    #----------------------------

    def import(remote_article, options={})
      import_to_class = options[:import_to_class] || "NewsStory"

      client = NPR::API::Client.new(url: API_ROOT)
      response = client.query(
        :path   => API_LIST_PATH,
        :apiKey => "", # Don't send our NPR API key to Publish2
        :output => "", # Publish2 uses the "format" param instead
        :format => 'json',
        :user   => Rails.application.config.api['publish2']['user'],
        :pass   => Rails.application.config.api['publish2']['pass'],
        :id     => remote_article.article_id
      )

      return false if !response.list

      npr_story = response.list.stories.first
      return false if !npr_story

      text = begin
        if npr_story.textWithHtml.present?
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
        article.news_agency   = "CHR"
        article.source        = "chr"
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
      if link = npr_story.link_for('html')
        related_link = RelatedLink.new(
          :link_type => "website",
          :title     => "View this story at Center for Health Reporting",
          :url      => link
        )

        article.related_links.push related_link
      end


      #-------------------
      # Add in the primary asset if it exists
      if image = npr_story.primary_image
        asset = AssetHost::Asset.create(
          :url     => image.src,
          :title   => image.title,
          :caption => image.caption,
          :owner   => [image.producer, image.provider].join("/"),
          :note    => "Imported from CHR: #{npr_story.link_for('html')}"
        )

        if asset && asset.id
          content_asset = ContentAsset.new(
            :position   => 0,
            :asset_id   => asset.id,
            :caption    => image.caption
          )

          article.assets << content_asset
        end
      end


      #-------------------
      # Save the news story (including all associations),
      # set the RemoteArticle to `:is_new => false`,
      # and return the NewsStory that was generated.
      article.save!
      remote_article.update_attribute(:is_new, false)
      article
    end

    add_transaction_tracer :import, category: :task
  end
end
