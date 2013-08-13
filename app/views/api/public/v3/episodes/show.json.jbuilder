json.partial! api_view_path("shared", "version")

json.episode do
  json.partial! api_view_path("episodes", "episode"), episode: @episode
end
