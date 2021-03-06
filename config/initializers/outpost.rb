# We need to register models somewhere, because theoretically 
# someone could visit the admin page before a class is loaded.
# The other option is to eager load all classes, which breaks
# some cool Rails functionality.
# Use strings here so the classes aren't loaded yet.

Outpost::Config.configure do |config|
  config.registered_models = [
    "Abstract",
    "AdminUser",
    "Bio",
    "Blog",
    "BlogEntry",
    "BreakingNewsAlert",
    "Category",
    "ContentShell",
    "DataPoint",
    "Edition",
    "Event",
    "ExternalProgram",
    "FeaturedComment",
    "FeaturedCommentBucket",
    "Flatpage",
    "Homepage",
    "KpccProgram",
    "MissedItBucket",
    "NewsStory",
    "PijQuery",
    "Podcast",
    "PressRelease",
    "RecurringScheduleRule",
    "RemoteArticle",
    "ScheduleOccurrence",
    "ShowEpisode",
    "ShowSegment"
  ]
  
  config.user_class                   = "AdminUser"
  config.authentication_attribute     = :username
  config.title_attributes             = [:name, :headline, :short_headline, :title]
  config.excluded_form_fields         = ["django_content_type_id"]
  config.excluded_list_columns        = ["body", "django_content_type_id"]
end


module Outpost
  module Controller
    module CustomErrors
      def report_error(e)
        ::NewRelic.log_error(e)
      end
    end
  end
end
