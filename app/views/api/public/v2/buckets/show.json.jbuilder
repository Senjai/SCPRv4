json.partial! "api/public/v2/buckets/bucket", bucket: @bucket

json.articles do
  json.partial! "api/public/v2/articles/collection",
    articles: @bucket.articles
end
