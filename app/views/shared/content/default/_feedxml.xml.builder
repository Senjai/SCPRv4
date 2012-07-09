xml.item do
  xml.title content.headline
  xml.guid  content.remote_link_path
  xml.link  content.remote_link_path
  
  b = render_byline(content,false)
  if b
    xml.dc :creator, b
  end
  
  if content.audio.present?
    xml.enclosure url: content.audio.first.url, type: "audio/mpeg", length: content.audio.first.size
  end
  
  descript = ""
  
  descript << render_asset(content,"feedxml")
  descript << render_content_body(content)
  
  if content.is_a? ContentShell
    descript << content_tag(:p, link_to("Read the full article at #{content.site}".html_safe, content.link_path))
  end
  
  xml.description descript
  
  xml.pubDate content.public_datetime.rfc822
end
