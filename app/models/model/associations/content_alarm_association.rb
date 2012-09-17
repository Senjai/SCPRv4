##
# ContentAlarmAssociation
#
# Association definition for content_alarm
#
module Model
  module Associations
    module ContentAlarmAssociation
      extend ActiveSupport::Concern
      
      included do
        has_one :alarm, as: :content, class_name: "ContentAlarm", dependent: :destroy
      end
    end
  end
end
