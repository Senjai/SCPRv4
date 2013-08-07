json.partial! api_view_path("shared", "version")

json.editions do
  json.partial! api_view_path("editions", "collection"), editions: @editions
end
