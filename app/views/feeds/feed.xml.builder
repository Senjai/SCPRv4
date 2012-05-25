xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title       @feed[:title]
    xml.link        @feed[:link] || "http://www.scpr.org"
    xml.description @feed[:description]
  
    xml << render_content(@content.first(15),"feedxml")
  end
end
