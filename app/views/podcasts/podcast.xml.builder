content_cache("podcast:#{@podcast.slug}") do
  register_content @obj_type
  
  xml.rss('version' => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd") do
    xml.channel do
      xml.title             @podcast.title
      xml.link              @podcast.link || "http://www.scpr.org"
      xml.description       h(@podcast.description)
      xml.itunes :author,    @podcast.author
      xml.itunes :summary,   h(@podcast.description)
    
      xml.itunes :owner do
        xml.itunes :name,  "KPCC 89.3 | Southern California Public Radio"
        xml.itunes :email, "contact@kpcc.org"
      end
    
      # need category
    
      xml.itunes :image, :href => @podcast.image_url
      xml.itunes :explicit, "no"
    
      if @content
        # Audio or not, we register the content for cache expiration
        # Limited to 25 items
        @content.each do |c|
          register_content c
        end
        
        # Only content with audio
        # Limited to 15 items
        @audio_content.each do |c|
          xml.item do |item|
            item.title              h(c.headline)
            item.itunes :author,    h(@podcast.author)
            item.itunes :summary,   h(c.teaser)
            item.description        h(c.teaser)
            item.guid               c.remote_link_path, :isPermaLink => true
            item.pubDate            c.published_at
            item.itunes :keywords,  h(@podcast.keywords)
            item.link               c.remote_link_path

            if c.audio.present?
              item.enclosure          :url => c.audio[0].podcast_url, :length => c.audio[0].size, :type => "audio/mpeg"
              item.itunes :duration,  c.audio.first.duration
            end
          end
        end
      end
    end
  end.html_safe
end
