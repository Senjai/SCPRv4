json.array! alerts do |alert|
  json.partial! "api/public/v2/alerts/alert", alert: alert
end
