##
# SetPublishedAtCallback
#
# Sets published_at depending on various things
# Required attributes: [:status, :published_at, :alarm]
# Requires a has_one association with ContentAlarm
#
# Note that these callbacks have to run before validation
# in order to validate slug uniqueness for `published_at`
#
# Scenarios:
# * Not publishing
#   - Do nothing
#
# * Publishing (status not published -> status published)
#   - Set `published_at` to Time.now if `published_at` is blank
#
# * Creating Content Alarm to publish in future
#   - Set `published_at` to alarm.fire_at if it has changed
#     So it can validate slug uniqueness for that date
#
# * Unpublishing (status published -> status not published)
#   - Set `published_at` to nil
#     So it can be set again later when re-publishing
#
module Model
  module Callbacks
    module SetPublishedAtCallback
      extend ActiveSupport::Concern
      
      included do
        before_validation :set_published_at_to_now,   if: :should_set_published_at_to_now?
        before_validation :set_published_at_to_alarm, if: :should_set_published_at_to_alarm?
        before_validation :set_published_at_to_nil,   if: :should_set_published_at_to_nil?
        
        #--------------
        
        # Run callback if publishing and published_at not set
        def should_set_published_at_to_now?
          self.publishing? and self.published_at.blank?
        end
        
        # If alarm is present and published_at not set
        def should_set_published_at_to_alarm?
          self.alarm.try(:fire_at_changed?)
        end
        
        # If unpublishing
        def should_set_published_at_to_nil?
          self.unpublishing?
        end

        #--------------
        
        # Status was changed and status is published
        def publishing?
           self.status_changed? and self.published?
        end
        
        # This assumes that any other status except STATUS_LIVE
        # is considered "not published". Maybe that won't always 
        # be true, for now it's fine.
        def unpublishing?
          self.status_was == ContentBase::STATUS_LIVE
        end        
        
        #--------------
        
        def set_published_at_to_now
          self.published_at = Time.now
        end
        
        def set_published_at_to_alarm
          self.published_at = self.alarm.fire_at
        end
        
        def set_published_at_to_nil
          self.published_at = nil
        end
        
        #--------------
      end
    end
  end
end
