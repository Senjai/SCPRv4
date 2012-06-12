xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title       @program.title
    xml.link        @program.remote_link_path
    xml.description @program.teaser
  
    xml << render_content(@segments.first(15),"feedxml")
  end
end
