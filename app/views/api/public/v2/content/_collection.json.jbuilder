# This exists so that we can render this from another 
# controller without having to set @content
json.array! content do |content|
  json.partial! "api/public/v2/content/content", content: content
end
