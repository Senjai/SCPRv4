# This exists so that we can render this from another 
# controller without having to set @article
json.array! articles do |article|
  json.partial! "api/public/v2/articles/article", article: article
end
