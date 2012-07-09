xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       @feed[:title]
    xml.link        @feed[:link] || "http://www.scpr.org"
    xml.atom :link, href: program_url(@program, format: :xml), rel: "self", type: "application/rss+xml"
    xml.description @feed[:description]
  
    xml << render_content(@content.first(15),"feedxml")
  end
end
