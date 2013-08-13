json.partial! api_view_path("shared", "version")

json.blogs do
  json.partial! api_view_path("blogs", "collection"), blogs: @blogs
end
