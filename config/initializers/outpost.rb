# We need to register models somewhere, because theoretically 
# someone could visit the admin page before a class is loaded.
# The other option is to eager load all classes, which breaks
# some cool Rails functionality.
# Use strings here so the classes aren't loaded yet.

Outpost::Config.configure do |config|
  config.registered_models = [
    "NewsStory", 
    "NprStory",
    "ContentShell", 
    "VideoShell", 
    "PijQuery", 
    "BlogEntry",
    "Blog", 
    "ShowSegment", 
    "ShowEpisode", 
    "KpccProgram", 
    "OtherProgram", 
    "RecurringScheduleSlot", 
    "Podcast",
    "Event",
    "Homepage", 
    "BreakingNewsAlert", 
    "MissedItBucket", 
    "FeaturedComment", 
    "FeaturedCommentBucket", 
    "Category", 
    "Section",
    "Flatpage", 
    "Promotion", 
    "AdminUser", 
    "Bio",
    "DataPoint",
    "PressRelease"
  ]
  
  config.user_class                   = "AdminUser"
  config.authentication_attribute     = :username
  config.title_attributes             = [:name, :short_headline, :title, :headline]
  config.excluded_form_fields         = ["django_content_type_id"]
  config.excluded_list_columns        = ["body", "django_content_type_id"]
end
