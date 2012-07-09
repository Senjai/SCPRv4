xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       "Blog: #{@blog.name} | 89.3 KPCC"
    xml.link        blog_url(@blog.slug)
    xml.atom :link, href: blog_url(@blog.slug, format: :xml), rel: "self", type: "application/rss+xml"
    xml.description sanitize(@blog.description)
  
    xml << render_content(@scoped_entries.first(15),"feedxml")
  end
end
