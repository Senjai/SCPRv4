xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title       "Latest Arts | 89.3 KPCC"
    xml.link        latest_arts_url
    xml.description "The latest arts & life articles from KPCC's award-winning news team."
  
    xml << render_content(@content,"feedxml")
  end
end
