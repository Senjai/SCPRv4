# This exists so that we can render this from another 
# controller without having to set @content
json.array! audio do |a|
  json.partial! "api/public/v2/audio/audio", audio: a
end
