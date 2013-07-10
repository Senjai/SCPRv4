# Since we actually want to return an empty object in this case, 
# we need to check if it exists first. The controller isn't catching it
# here like it is in the other controllers.
if @schedule_occurrence
  json.partial! "api/public/v2/schedule_occurrences/schedule_occurrence",
    :schedule_occurrence => @schedule_occurrence
end
