json.cache! [Api::Public::V3::VERSION, "v2", category] do
  json.id            category.id
  json.slug          category.slug
  json.title         category.title
  json.public_url    category.public_url
end
