# This exists so that we can render this from another 
# controller without having to set @content
json.array! categories do |category|
  json.partial! "api/public/v2/categories/category", category: category
end
