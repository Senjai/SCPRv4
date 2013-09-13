json.array! embeds do |embed|
  json.partial! api_view_path("embeds", "embed"), embed: embed
end
