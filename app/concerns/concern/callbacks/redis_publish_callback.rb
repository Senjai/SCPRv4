##
# RedisPublishCallback
#
# Sends message to Redis pub/sub
# Requires the methods defined in PublishingMethods
#
# This has to match what Mercer is doing for now.
#
module Concern
  module Callbacks
    module RedisPublishCallback
      extend ActiveSupport::Concern
      
      included do
        include Concern::Methods::PublishingMethods
        after_save :publish_to_redis
      end

      #---------------------------
      
      def publish_to_redis
        if !self.status_changed?
          Publisher.publish(object: self, action: "save", 
            options: { status_change: false })
        else
          if self.publishing?
            Publisher.publish(object: self, action: "publish",
              options: { status_change: true, old_status: self.status_was })
          elsif self.unpublishing?
            Publisher.publish(object: self, action: "unpublish",
             options: { status_change: true, old_status: self.status_was })
          else
            Publisher.publish(object: self, action: "save",
              options: { status_change: true, old_status: self.status_was })
          end
        end
      end
    end # CacheExpiration
  end # Callbacks
end # Concern
