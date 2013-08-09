json.array! schedule_occurrences do |schedule_occurrence|
  json.partial! api_view_path("schedule_occurrences", "schedule_occurrence"), schedule_occurrence: schedule_occurrence
end
