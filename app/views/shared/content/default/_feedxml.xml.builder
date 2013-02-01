enclosure_type ||= content.respond_to?(:audio) ? :audio : :image

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
      asset = content.assets.first.asset
      xml.enclosure url: asset.thumb.url, type: "image/jpeg", length: asset.image_file_size.to_i / 100
    end
  else
    if content.try(:audio).present?
      audio = content.audio.first
      xml.enclosure url: audio.url, type: "audio/mpeg", 
                    length: audio.size.present? ? audio.size : "0"
    end
  end
  
  descript = ""
  
  descript << render_asset(content,"feedxml")
  descript << relaxed_sanitize(content.body)
  
  if content.is_a? ContentShell
    descript << content_tag(:p, link_to("Read the full article at #{content.site}".html_safe, content.link_path))
  end
  
  xml.description descript
  
  xml.pubDate content.published_at.rfc822
end
