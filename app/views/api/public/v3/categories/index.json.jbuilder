json.partial! api_view_path("shared", "version")

json.categories do
  json.partial! api_view_path("categories", "collection"),
    categories: @categories
end
