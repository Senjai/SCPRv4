json.cache! [Api::Public::V3::VERSION, "v2", bucket] do
  json.title         bucket.title
  json.slug          bucket.slug
  json.updated_at    bucket.updated_at

  # ARTICLES are injected into the object in the show template.
end
