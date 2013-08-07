json.partial! api_view_path("shared", "version")

json.category do
  json.partial! api_view_path("categories", "category"), category: @category
end
