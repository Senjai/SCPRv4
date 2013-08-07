json.partial! api_view_path("shared", "version")

json.schedule_occurrences do
  json.partial! api_view_path("schedule_occurrences", "collection"),
    schedule_occurrences: @schedule_occurrences
end
