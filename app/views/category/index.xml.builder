xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       "#{@category.category} | 89.3 KPCC"
    xml.link        category_url(@category.slug)
    xml.atom :link, href: category_url(@category.slug, format: :xml), rel: "self", type: "application/rss+xml"
    xml.description "The latest #{@category.category} news from KPCC's award-winning news team."
  
    xml << render_content(@content,"feedxml")
  end
end
