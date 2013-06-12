json.cache! [Api::Public::V2::VERSION, "v1", category] do
  json.id     category.id
  json.slug   category.slug
  json.title  category.title
  json.url    category.public_url
end
