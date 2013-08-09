json.partial! api_view_path("shared", "version")

json.episodes do
  json.partial! api_view_path("episodes", "collection"), episodes: @episodes
end
