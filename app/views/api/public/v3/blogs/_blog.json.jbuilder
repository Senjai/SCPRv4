json.cache! [Api::Public::V3::VERSION, "v2", blog] do
  json.title        blog.name
  json.slug         blog.slug

  json.tagline      blog.teaser.to_s.html_safe
  json.description  blog.description.to_s.html_safe

  if link = blog.get_link("rss")
    json.rss_url link
  end

  json.public_url   blog.public_url
end
