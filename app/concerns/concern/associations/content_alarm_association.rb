##
# ContentAlarmAssociation
#
# Association definition for content_alarm
# Also includes related callbacks
#
# It's important that content_alarm is a has_one association, because
# this takes advantage of the fact that you can just save right over the old one.
# We do this to keep the code simple - rather than trying to update the alarm, just
# make a new one when the published_at date is changed.
#
# Required attributes: [:status, :pending?, :published_at, :unpublishing]
#
module Concern
  module Associations
    module ContentAlarmAssociation
      extend ActiveSupport::Concern
      
      included do
        has_one :alarm, as: :content, class_name: "ContentAlarm", dependent: :destroy
        before_save :generate_alarm, if: :should_generate_alarm?
        before_save :destroy_alarm, if: :should_destroy_alarm?
      end
      
      #------------------
      # When to generate an alarm
      def should_generate_alarm?
        self.pending? && self.published_at_changed? && self.published_at.present?
      end
      
      #------------------
      # If we're changing status from Pending to something else,
      # and there was an alarm, get rid of it.
      def should_destroy_alarm?
        self.alarm.present? && self.status_changed? && self.status_was == ContentBase::STATUS_PENDING
      end
      
      #------------------
      # Build an alarm
      # Double-check that published_at is present, otherwise errors.
      def generate_alarm
        if self.published_at.present?
          self.build_alarm(fire_at: self.published_at)
        end
      end
      
      #------------------
      # Mark the alarm for destruction
      def destroy_alarm
        self.alarm.mark_for_destruction
      end
    end # ContentAlarmAssociation
  end # Associations
end # Concern
