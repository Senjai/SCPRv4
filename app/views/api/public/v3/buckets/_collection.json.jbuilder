# This exists so that we can render this from another 
# controller without having to set @content
json.array! buckets do |bucket|
  json.partial! api_view_path("buckets", "bucket"), bucket: bucket
end
