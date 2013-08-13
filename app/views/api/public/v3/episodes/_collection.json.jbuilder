json.array! episodes do |episode|
  json.partial! api_view_path("episodes", "episode"), episode: episode
end
