json.partial! api_view_path("shared", "version")

json.buckets do
  json.partial! api_view_path("buckets", "collection"), buckets: @buckets
end
