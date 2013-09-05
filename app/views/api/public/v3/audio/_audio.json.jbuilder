json.cache! [Api::Public::V3::VERSION, "v2", audio] do
  json.id               audio.id
  json.description      audio.description
  json.url              audio.url
  json.byline           audio.byline
  json.uploaded_at      audio.created_at
  json.position         audio.position
  json.duration         audio.duration
  json.filesize         audio.size
  json.article_obj_key  audio.content.obj_key
end
