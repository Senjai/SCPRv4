json.cache! [Api::Public::V2::VERSION, "v1", category] do
  json.id            category.id
  json.slug          category.slug
  json.title         category.title
  json.public_url    category.public_url
  
  json.url category.public_url # Deprecated
end
