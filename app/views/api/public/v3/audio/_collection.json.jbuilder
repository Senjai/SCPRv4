# This exists so that we can render this from another 
# controller without having to set @content
json.array! audio do |a|
  json.partial! api_view_path("audio", "audio"), audio: a
end
