##
# PublishingMethods
#
# A set of methods to help with determining
# the status changes for an object
#
# Required attributes: [:status, :published?]
#
module Concern
  module Methods
    module PublishingMethods
      # Status was changed and status is published
      def publishing?
        self.status_changed? && self.published?
      end

      # Status was changed and status is not published
      def unpublishing?
        self.status_changed? && !self.published?
      end
    end
  end
end
