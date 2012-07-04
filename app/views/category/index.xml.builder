xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title       "#{@category.category} | 89.3 KPCC"
    xml.link        section_url(@category.slug)
    xml.description "The latest #{@category.category} news from KPCC's award-winning news team."
  
    xml << render_content(@content,"feedxml")
  end
end
