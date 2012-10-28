# We need to register models somewhere, because theoretically 
# someone could visit the admin page before a class is loaded.
# The other option is to eager load all classes, which breaks
# some cool Rails functionality.
# Use strings here so the classes aren't loaded yet.

require_dependency 'admin_resource'

AdminResource::Config.configure do |config|
  config.registered_models = [
    "NewsStory", 
    "ContentShell", 
    "VideoShell", 
    "PijQuery", 
    "BlogEntry", 
    "Blog", 
    "Tag",
    "ShowSegment", 
    "ShowEpisode", 
    "KpccProgram", 
    "OtherProgram", 
    "Schedule", 
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
    "Permission",
    "DataPoint"
  ]
    
    
  config.nav_groups = {
    "News" => {
      icon: "icon-file",
      models: [
        "NewsStory",
        "ContentShell",
        "VideoShell",
#        "NprStory",
        "PijQuery"
      ]
    },
    
    "Blogs" => {
      icon: "icon-edit",
      models: [
        "BlogEntry",
        "Blog",
        "Tag"
      ]
    },
    
    "Programs" => {
      icon: "icon-headphones",
      models: [
        "ShowSegment",
        "ShowEpisode",
        "KpccProgram",
        "OtherProgram",
        "Schedule",
        "Podcast"
      ]
    },
    
    "Events" => {
      icon: "icon-calendar",
      models: [
        "Event"
      ]
    },
    
    "Homepages & Collections" => {
      icon: "icon-home",
      models: [
        "Homepage",
        "BreakingNewsAlert",
        "MissedItBucket",
        "FeaturedComment",
        "FeaturedCommentBucket",
        "Category",
        "Section"
      ]
    },
    
    "Other Content" => {
      icon: "icon-bookmark",
      models: [
        "Flatpage",
        "Promotion",
        "DataPoint"
#        "PressRelease"
      ]
    },
    
    "User Management" => {
      icon: "icon-user",
      models: [
        "AdminUser",
        "Bio"
      ]
    }
  }
  
  config.title_attributes      = [:name, :short_headline, :title, :headline]
  config.excluded_form_fields  = ["django_content_type_id"]
  config.excluded_list_columns = ["body", "django_content_type_id"]
end
