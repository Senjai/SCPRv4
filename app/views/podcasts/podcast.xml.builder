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

    @content.select { |c| c.audio.available.present? }.first(15).each do |content|
      audio = content.audio.available.first
      
      xml.item do |item|
        item.title              raw(content.headline)
        item.itunes :author,    raw(@podcast.author)
        item.itunes :summary,   raw(content.teaser)
        item.description        raw(content.teaser)
        item.guid               content.remote_link_path, :isPermaLink => true
        item.pubDate            content.published_at
        item.itunes :keywords,  raw(@podcast.keywords)
        item.link               content.remote_link_path

        item.enclosure          :url    => audio.podcast_url, 
                                :length => audio.size, 
                                :type   => "audio/mpeg"
                              
        item.itunes :duration,  audio.duration
      end # xml
    end # @content
  end # xml.channel
end.html_safe #xml.rss
