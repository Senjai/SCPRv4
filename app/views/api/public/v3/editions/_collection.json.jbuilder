# This exists so that we can render this from another 
# controller without having to set @content
json.array! editions do |edition|
  json.partial! api_view_path("editions", "edition"), edition: edition
end
