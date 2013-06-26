json.array! schedule_slots do |schedule_slot|
  json.partial! "api/public/v2/schedule_slots/schedule_slot", schedule_slot: schedule_slot
end
