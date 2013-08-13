json.partial! api_view_path("shared", "version")

# Since we actually want to return an empty object in this case, 
# we need to check if it exists first. The controller isn't catching it
# here like it is in the other controllers.
json.schedule_occurrence do
  if @schedule_occurrence
    json.partial! api_view_path("schedule_occurrences", "schedule_occurrence"),
      schedule_occurrence: @schedule_occurrence
  end
end
