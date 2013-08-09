# This exists so that we can render this from another 
# controller without having to set @content
json.array! categories do |category|
  json.partial! api_view_path("categories", "category"), category: category
end
