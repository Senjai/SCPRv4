json.array! breaking_news_alerts do |breaking_news_alert|
  json.partial! "api/public/v2/breaking_news_alerts/breaking_news_alert",
    breaking_news_alert: breaking_news_alert
end
