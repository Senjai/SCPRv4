json.partial! api_view_path("shared", "version")

json.bucket do
  json.partial! api_view_path("buckets", "bucket"), bucket: @bucket

  json.articles do
    json.partial! api_view_path("articles", "collection"),
      articles: @bucket.articles
  end
end
