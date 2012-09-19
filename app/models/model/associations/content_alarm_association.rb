##
# ContentAlarmAssociation
#
# Association definition for content_alarm
# Also includes related callbacks
#
module Model
  module Associations
    module ContentAlarmAssociation
      extend ActiveSupport::Concern
      
      included do
        has_one :alarm, as: :content, class_name: "ContentAlarm", dependent: :destroy
        accepts_nested_attributes_for :alarm, reject_if: :should_reject_alarm?, allow_destroy: true
        
        before_save :mark_alarm_for_destruction, if: :should_destroy_alarm?
        
        #------------------
        
        # If we're changing status from Pending to something else,
        # and there was an alarm, get rid of it.
        def should_destroy_alarm?
          self.alarm.present? and self.status_changed? and self.status_was == ContentBase::STATUS_PENDING
        end
        
        def should_reject_alarm?(attributes)
          attributes['fire_at'].blank?
        end

        #------------------

        def destroy_alarm
          self.alarm.mark_for_destruction
        end
      end
    end
  end
end
