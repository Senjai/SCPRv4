# This exists so that we can render this from another 
# controller without having to set @asset
json.array! embeds do |embed|
  json.partial! "api/public/v2/embeds/embed", embed: embed
end
