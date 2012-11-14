module Concern
  module Methods
    module StatusMethods
      extend ActiveSupport::Concern
      
      included do
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
        
        #-----------------
        
        def status_text
          ContentBase::STATUS_TEXT[ self.status ]
        end
      end
    end
  end
end
