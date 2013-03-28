xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       "#{@category.title} | 89.3 KPCC"
    xml.link        @category.remote_link_path
    xml.atom :link, href: @category.remote_link_path(format: :xml), rel: "self", type: "application/rss+xml"
    xml.description "The latest #{@category.title} news from KPCC's award-winning news team."
  
    xml << render_content(@content,"feedxml")
  end
end
