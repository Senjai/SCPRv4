# This exists so that we can render this from another 
# controller without having to set @content
json.array! events do |event|
  json.partial! api_view_path("events", "event"), event: event
end
