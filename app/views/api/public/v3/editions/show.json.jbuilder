json.partial! api_view_path("shared", "version")

json.edition do
  json.partial! api_view_path("editions", "edition"), edition: @edition
end
