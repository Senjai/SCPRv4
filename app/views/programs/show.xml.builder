xml.rss(RSS_SPEC) do
  xml.channel do
    xml.title       "#{@program.title} | 89.3 KPCC"
    xml.link        program_url(@program)
    xml.atom :link, href: program_url(@program, format: :xml), rel: "self", type: "application/rss+xml"
    xml.description sanitize(@program.teaser)
  
    xml << render_content(@segments_scoped.first(15),"feedxml")
  end
end
