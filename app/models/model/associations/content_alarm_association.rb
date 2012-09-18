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
        accepts_nested_attributes_for :alarm, reject_if: ->(attributes) { attributes['fire_at'].blank? }
        
        before_save :destroy_content_alarm, if: :should_destroy_content_alarm?
        after_save  :create_content_alarm,  if: :should_create_content_alarm?
        
        #------------------
        
        def should_create_content_alarm?
          self.pending? and self.alarm.fire_at.present?
        end
        
        def should_destroy_content_alarm?
        end
        
        #------------------
        
        def create_content_alarm
          ContentAlarm.generate(self)
        end
        
        def destroy_content_alarm
          self.alarm.destroy
        end
      end
    end
  end
end
