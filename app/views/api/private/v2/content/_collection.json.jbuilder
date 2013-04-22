# This exists so that we can render this from another 
# controller without having to set @content
# Specify the full partial path so it'll work when we render it
# from another controller or view.
json.array! content do |content|
  json.partial! "api/private/v2/content/content", content: content
end
