json.array! alerts do |alert|
  json.partial! api_view_path("alerts", "alert"), alert: alert
end
