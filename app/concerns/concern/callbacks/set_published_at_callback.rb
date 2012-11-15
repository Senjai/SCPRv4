##
# SetPublishedAtCallback
#
# Sets published_at depending on various things
# Required attributes: [:published_at, :alarm, :publishing?, :unpublishing?]
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
module Concern
  module Callbacks
    module SetPublishedAtCallback
      extend ActiveSupport::Concern
      
      included do
        before_validation :set_published_at_to_now,   if: :should_set_published_at_to_now?
        before_validation :set_published_at_to_alarm, if: :should_set_published_at_to_alarm?
        before_validation :set_published_at_to_nil,   if: :should_set_published_at_to_nil?
      end

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
      
      def set_published_at_to_now
        self.published_at = Time.now
      end
      
      def set_published_at_to_alarm
        self.published_at = self.alarm.fire_at
      end
      
      def set_published_at_to_nil
        self.published_at = nil
      end
    end # SetPublishedAtCallback
  end # Callbacks
end # Concern
