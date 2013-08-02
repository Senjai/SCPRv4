json.cache! [Api::Public::V2::VERSION, "v1", schedule_occurrence] do
  json.title          schedule_occurrence.title
  json.public_url     schedule_occurrence.public_url
  json.starts_at      schedule_occurrence.starts_at
  json.ends_at        schedule_occurrence.ends_at
  json.is_recurring   schedule_occurrence.is_recurring?

  if schedule_occurrence.program.present?
    json.program do
      json.partial! "api/public/v2/programs/program",
        :program => schedule_occurrence.program
    end
  end
end
