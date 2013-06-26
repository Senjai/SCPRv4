json.array! episodes do |episode|
  json.partial! "api/public/v2/episodes/episode", episode: episode
end
