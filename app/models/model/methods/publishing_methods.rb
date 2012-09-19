##
# PublishingMethods
# A set of methods to help with determining
# the status changes for an object
#
# Required attributes: [:status, :published?]
#
module Model
  module Methods
    module PublishingMethods
      extend ActiveSupport::Concern
      
      included do
        # Status was changed and status is published
        def publishing?
           @publishing ||= self.status_changed? and self.published?
        end
        
        # This assumes that any other status except STATUS_LIVE
        # is considered "not published". Maybe that won't always 
        # be true, for now it's fine.
        def unpublishing?
          @unpublishing ||= self.status_changed? and self.status_was == ContentBase::STATUS_LIVE
        end
      end
    end
  end
end
