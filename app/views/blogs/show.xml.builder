xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title       "Blog: #{@blog.name} | 89.3 KPCC"
    xml.link        blog_url(@blog.slug)
    xml.description @blog.description
  
    xml << render_content(@scoped_entries.first(15),"feedxml")
  end
end
