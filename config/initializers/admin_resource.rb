# We need to register models somewhere, because theoretically 
# someone could visit the admin page before a class is loaded.
# The other option is to eager load all classes, which breaks
# some cool Rails functionality.
# Use strings here so the classes aren't loaded yet.

require_dependency 'admin_resource'

# Monkey patches for Mercer additions
module AdminResource
  module Model
    module Routing
      module ClassMethods
        def django_admin_url
          "http://scpr.org/admin/#{self.table_name.gsub("_", "/")}"
        end
      end
      
      #-----------------
      
      def django_edit_url
        [self.class.django_admin_url, self.id || "add"].join "/"
      end
    end # Routing

    #-----------------
    
    module Methods
      module ClassMethods
        # We're going to assume that if the table name does not use 
        # Rails conventions, then this feature was never built in Django
        def exists_in_django?
          @exists_in_django ||= self.table_name != self.name.tableize
        end
      end

      #-----------------
    
      def exists_in_django?
        self.class.exists_in_django?
      end
    end
  end
end


AdminResource::Config.configure do |config|
  config.registered_models = [
    "NewsStory", 
    "NprStory",
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
    "Permission",
    "DataPoint",
    "PressRelease"
  ]
    
    
  config.nav_groups = {
    "News" => {
      icon: "icon-file",
      models: [
        "NewsStory",
        "ContentShell",
        "VideoShell",
        "NprStory",
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
        "RecurringScheduleSlot",
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
        "DataPoint",
        "PressRelease"
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
