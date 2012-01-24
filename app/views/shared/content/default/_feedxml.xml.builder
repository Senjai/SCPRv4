xml.item do
  xml.title content.headline
  xml.guid  content.remote_link_path
  xml.link  content.remote_link_path
  
  xml.dc :creator, render_byline(content,false)
  
  descript = ""
  
  descript << render_asset(content,"feedxml")
  descript << simple_format(content.body, {}, :sanitize => false)
  
  xml.description descript
  
  xml.pubDate content.public_datetime.rfc822
end