xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       @feed[:title]
    xml.link        @feed[:link] || "http://www.scpr.org"
    xml.atom :link, href: all_news_feed_url(format: :xml), rel: "self", type: "application/rss+xml"
    xml.description @feed[:description]
  
    xml << render_content(@content.first(15),"feedxml", locals: { enclosure_type: :image })
  end
end
