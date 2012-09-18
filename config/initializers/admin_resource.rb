# We need to register models somewhere, because theoretically 
# someone could visit the admin page before a class is loaded.
# The other option is to eager load all classes, which breaks
# some cool Rails functionality.
# Use strings here so the classes aren't loaded yet.

require_dependency 'admin_resource'

AdminResource::Config.configure do |config|
  config.registered_models = [ 
    "Section", 
    "Promotion", 
    "Blog", 
    "BlogEntry", 
    "Tag", 
    "NewsStory", 
    "ContentShell", 
    "VideoShell", 
    "Homepage", 
    "Flatpage", 
    "KpccProgram", 
    "OtherProgram", 
    "ShowEpisode", 
    "ShowSegment", 
    "PijQuery"
  ]
  
  config.title_attributes = [:name, :short_headline, :title, :headline]
end
