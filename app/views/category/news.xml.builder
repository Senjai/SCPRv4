xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       "Latest News | 89.3 KPCC"
    xml.link        latest_news_url
    xml.atom :link, href: latest_news_url(format: :xml), rel: "self", type: "application/rss+xml"
    xml.description "Features and interviews from KPCC's award-winning news team."
  
    xml << render_content(@content,"feedxml")
  end
end
