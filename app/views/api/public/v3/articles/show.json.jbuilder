json.partial! api_view_path("shared", "version")

json.article do
  json.partial! api_view_path("articles", "article"), article: @article
end
