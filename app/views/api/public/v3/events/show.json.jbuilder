json.partial! api_view_path("shared", "version")

json.event do
  json.partial! api_view_path("events", "event"), event: @event
end
