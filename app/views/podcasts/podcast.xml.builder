xml.rss('version' => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd") do
  xml.channel do
    xml.title             @podcast.title
    xml.link              @podcast.link || "http://www.scpr.org"
    xml.description       @podcast.description
    xml.itunes :author,    @podcast.author
    xml.itunes :summary,   @podcast.description
    
    xml.itunes :owner do
      xml.itunes :name,  "KPCC 89.3 | Southern California Public Radio"
      xml.itunes :email, "contact@kpcc.org"
    end
    
    # need category
    
    xml.itunes :image, :href => @podcast.image_url
    xml.itunes :explicit, "no"
    
    @content.first(15).each do |c|
      xml.item do |item|
        item.title              c.headline
        item.itunes :author,    @podcast.author
        item.itunes :summary,   c.teaser
        item.description        c.teaser
        item.enclosure          :url => "", :length => "", :type => "audio/mpeg"
        item.guid               c.remote_link_path, :isPermaLink => true
        item.pubDate            c.published_at
        item.itunes :duration,  ""
        item.itunes :keywords,  @podcast.keywords
        item.link               c.remote_link_path
      end
    end
  
  end
end