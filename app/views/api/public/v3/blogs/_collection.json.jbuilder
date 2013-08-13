json.array! blogs do |blog|
  json.partial! api_view_path("blogs", "blog"), blog: blog
end
