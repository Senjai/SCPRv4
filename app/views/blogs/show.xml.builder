xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/", 'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       "Blog: #{@blog.name} | 89.3 KPCC"
    xml.link        blog_url(@blog.slug)
    xml.atom :link, href: blog_url(@blog.slug), rel: "self", type: "application/rss+xml"
    xml.description sanitize(@blog.description)
  
    xml << render_content(@scoped_entries.first(15),"feedxml")
  end
end
