json.cache! [Api::Public::V2::VERSION, "v1", blog] do
  json.title        blog.name
  json.slug         blog.slug

  json.tagline      blog.teaser.to_s.html_safe
  json.description  blog.description.to_s.html_safe

  json.rss_url(blog.feed_url) if blog.feed_url.present?
  json.public_url   blog.public_url
end
