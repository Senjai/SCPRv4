enclosure_type ||= :audio

xml.item do
  xml.title content.headline
  xml.guid  content.remote_link_path
  xml.link  content.remote_link_path
  
  b = render_byline(content,false)
  if b
    xml.dc :creator, b
  end
  
  if enclosure_type == :image
    if content.assets.first.present?
      thumb = content.assets.first.asset.thumb
      xml.enclosure url: thumb.url, type: "image/jpeg", length: thumb.image_file_size
    end
  else
    if content.audio.present?
      audio = content.audio.first
      xml.enclosure url: audio.url, type: "audio/mpeg", 
                    length: audio.size.present? ? audio.size : "0"
    end
  end
  
  descript = ""
  
  descript << render_asset(content,"feedxml")
  descript << sanitize(render_content_body(content), tags: %w{ br p i b s img em strong span div table tr td th })
  
  if content.is_a? ContentShell
    descript << content_tag(:p, link_to("Read the full article at #{content.site}".html_safe, content.link_path))
  end
  
  xml.description descript
  
  xml.pubDate content.public_datetime.rfc822
end
