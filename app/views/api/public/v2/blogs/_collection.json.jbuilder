json.array! blogs do |blog|
  json.partial! "api/public/v2/blogs/blog", blog: blog
end
