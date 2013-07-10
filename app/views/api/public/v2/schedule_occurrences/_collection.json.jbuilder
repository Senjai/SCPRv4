json.array! schedule_occurrences do |schedule_occurrence|
  json.partial! "api/public/v2/schedule_occurrences/schedule_occurrence", schedule_occurrence: schedule_occurrence
end
