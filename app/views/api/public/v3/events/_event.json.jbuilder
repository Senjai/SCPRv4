json.cache! [Api::Public::V3::VERSION, "v2", event] do
  json.id         event.id
  json.title      event.headline
  json.public_url event.public_url

  json.starts_at      event.starts_at
  json.ends_at        event.ends_at
  json.is_all_day     event.is_all_day

  json.teaser         event.teaser.html_safe
  json.body           event.body.html_safe

  if event.archive_description.present?
    json.past_tense_body event.archive_description.html_safe
  end

  json.hashtag        event.hashtag
  json.event_type     event.event_type
  json.is_kpcc_event  event.is_kpcc_event

  json.location do
    json.title event.location_name
    json.url   event.location_url

    json.address do
      json.line_1   event.address_1
      json.line_2   event.address_2
      json.city     event.city
      json.state    event.state
      json.zip_code event.zip_code
    end
  end

  json.sponsor do
    json.title event.sponsor
    json.url   event.sponsor_url
  end

  if event.kpcc_program.present?
    json.program do
      json.partial! api_view_path("programs", "program"),
        program: event.kpcc_program.to_program
    end
  end

  json.assets do |asset|
    json.partial! api_view_path("assets", "collection"),
      assets: event.assets
  end

  json.audio do
    json.partial! api_view_path("audio", "collection"),
      audio: event.audio
  end
end
