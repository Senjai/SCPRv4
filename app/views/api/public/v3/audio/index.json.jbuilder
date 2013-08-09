json.partial! api_view_path("shared", "version")

json.audio do
  json.partial! api_view_path("audio", "collection"), audio: @audio
end
