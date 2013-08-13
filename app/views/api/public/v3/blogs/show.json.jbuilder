json.partial! api_view_path("shared", "version")

json.blog do
  json.partial! api_view_path("blogs", "blog"), blog: @blog
end
