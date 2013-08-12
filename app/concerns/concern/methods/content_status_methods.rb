# Content Status Methods
#
# This should only be included into classes which
# use the ContentBase statuses.
module Concern
  module Methods
    module ContentStatusMethods
      def killed?
        self.status == ContentBase::STATUS_KILLED
      end

      def draft?
        self.status == ContentBase::STATUS_DRAFT
      end

      def awaiting_rework?
        self.status == ContentBase::STATUS_REWORK
      end

      def awaiting_edits?
        self.status == ContentBase::STATUS_EDIT
      end

      def pending?
        self.status == ContentBase::STATUS_PENDING
      end

      def published?
        self.status == ContentBase::STATUS_LIVE
      end


      def status_text
        ContentBase::STATUS_TEXT[self.status]
      end

      # Publish this article
      def publish
        self.update_attribute(:status, ContentBase::STATUS_LIVE)
      end
    end
  end
end
