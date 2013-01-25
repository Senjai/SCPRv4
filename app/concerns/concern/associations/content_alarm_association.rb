##
# ContentAlarmAssociation
#
# Association definition for content_alarm
# Also includes related callbacks
#
# Required attributes: [:status]
#
module Concern
  module Associations
    module ContentAlarmAssociation
      extend ActiveSupport::Concern
      
      included do
        has_one :alarm, as: :content, class_name: "ContentAlarm", dependent: :destroy
        accepts_nested_attributes_for :alarm, reject_if: :should_reject_alarm?, allow_destroy: true

        before_save :destroy_alarm, if: :should_destroy_alarm?
      end

      #------------------
      # Reject if the alarm doesn't already exist and the fire_at
      # wasn't filled in.
      #
      # This allows someone to remove the scheduled publishing by
      # clearing out the fire_at fields.
      def should_reject_alarm?(attributes)
        self.alarm.blank? && attributes['fire_at'].blank?
      end
      
      #------------------
      # If we're changing status from Pending to something else,
      # and there was an alarm, get rid of it.
      # Also get rid of it if we saved it with blank fire_at fields.
      def should_destroy_alarm?
        (self.alarm.present? && self.status_changed? && self.status_was == ContentBase::STATUS_PENDING) ||
        (self.alarm.present? && self.alarm.fire_at.blank?)
      end
      
      #------------------
      # Mark the alarm for destruction
      def destroy_alarm
        self.alarm.mark_for_destruction
      end
    end # ContentAlarmAssociation
  end # Associations
end # Concern
