cache ["v1", @podcast], expires_in: 1.hour do # Podcasts will refresh every hour.
  xml.rss('version' => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd") do
    xml.channel do
      xml.title             @podcast.title
      xml.link              @podcast.url || "http://www.scpr.org"
      xml.description       h(@podcast.description)
      xml.itunes :author,   @podcast.author
      xml.itunes :summary,  h(@podcast.description)
  
      xml.itunes :owner do
        xml.itunes :name,  "KPCC 89.3 | Southern California Public Radio"
        xml.itunes :email, "contact@kpcc.org"
      end
  
      # need category
  
      xml.itunes :image, :href => @podcast.image_url
      xml.itunes :explicit, "no"

      @articles.select { |c| c.audio.present? }.first(15).each do |article|
        audio = article.audio.first
      
        xml.item do |item|
          item.title              raw(article.title)
          item.itunes :author,    raw(@podcast.author)
          item.itunes :summary,   raw(article.teaser)
          item.description        raw(article.teaser)
          item.guid               article.public_url, :isPermaLink => true
          item.pubDate            article.public_datetime.in_time_zone("GMT").strftime("%a, %d %b %Y %T %Z")
          item.itunes :keywords,  raw(@podcast.keywords)
          item.link               article.public_url

          item.enclosure          :url    => audio.podcast_url,
                                  :length => audio.size,
                                  :type   => "audio/mpeg"
                              
          item.itunes :duration,  audio.duration
        end # xml
      end # @article
    end # xml.channel
  end.html_safe #xml.rss
end # cache
