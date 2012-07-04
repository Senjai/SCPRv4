xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title       "Latest News | 89.3 KPCC"
    xml.link        latest_news_url
    xml.description "Features and interviews from KPCC's award-winning news team."
  
    xml << render_content(@content,"feedxml")
  end
end
