xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/", 'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       "#{@program.title} | 89.3 KPCC"
    xml.link        @program.remote_link_path
    xml.atom :link, href: @program.remote_link_path, rel: "self", type: "application/rss+xml"
    xml.description sanitize(@program.teaser)
  
    xml << render_content(@segments_scoped.first(15),"feedxml")
  end
end
