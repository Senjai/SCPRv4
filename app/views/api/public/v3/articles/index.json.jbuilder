json.partial! api_view_path("shared", "version")

json.articles do
  json.partial! api_view_path("articles", "collection"), articles: @articles
end
