json.partial! api_view_path("shared", "version")

json.events do
  json.partial! api_view_path("events", "collection"), events: @events
end
