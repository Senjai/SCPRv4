json.cache! [Api::Public::V3::VERSION, "v2", alert] do
  json.id             alert.id
  json.headline       alert.headline
  json.type           alert.alert_type
  json.published_at   alert.published_at

  if alert.alert_url.present?
    json.public_url alert.alert_url
  end

  if alert.teaser.present?
    json.teaser alert.teaser
  end

  json.mobile_notification_sent alert.mobile_notification_sent?
  json.email_notification_sent  alert.email_sent?
end
