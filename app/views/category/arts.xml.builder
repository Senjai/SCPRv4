xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       "Latest Arts | 89.3 KPCC"
    xml.link        latest_arts_url
    xml.atom :link, href: latest_arts_url(format: :xml), rel: "self", type: "application/rss+xml"
    xml.description "The latest arts & life articles from KPCC's award-winning news team."
  
    xml << render_content(@content,"feedxml")
  end
end
