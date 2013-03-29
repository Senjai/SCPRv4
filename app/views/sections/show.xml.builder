xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       "#{@section.title} | 89.3 KPCC"
    xml.link        @section.remote_link_path
    xml.atom :link, href: @section.remote_link_path(format: :xml), rel: "self", type: "application/rss+xml"
    xml.description "The latest #{@section.title} news from KPCC's award-winning news team."
  
    xml << render_content(@section.content,"feedxml")
  end
end
