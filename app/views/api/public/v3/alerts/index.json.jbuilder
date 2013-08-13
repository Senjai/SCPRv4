json.partial! api_view_path("shared", "version")

json.alerts do
  json.partial! api_view_path("alerts", "collection"), alerts: @alerts
end
