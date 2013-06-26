json.cache! [Api::Public::V2::VERSION, "v1", schedule_slot] do
  json.title          schedule_slot.title
  json.public_url     schedule_slot.public_url
  json.starts_at      schedule_slot.starts_at
  json.ends_at        schedule_slot.ends_at

end
