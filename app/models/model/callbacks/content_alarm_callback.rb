##
# ContentAlarmCallback
# Creates a content alarm if needed
#
# Required attributes: [:alarm]
# Required methods: [:pending?]
module Model
  module Callbacks
    module ContentAlarmCallback
      extend ActiveSupport::Concern
      
      included do
#        after_save :create_content_alarm, if: :should_create_content_alarm?
        
        #------------------
        
        def should_create_content_alarm?
        end

        #------------------
        
        def create_content_alarm
          ContentAlarm.generate(self)
        end
      end
    end
  end
end
