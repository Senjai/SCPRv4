##
# Publishing Callback
# Updates published_at date if publishing
# Required fields: [:status, :published_at]
#
module Model
  module Callbacks
    module PublishingCallback
      extend ActiveSupport::Concern
    
      included do
        before_save :set_published_at_to_now, if: :publishing?
        
        def set_published_at_to_now
          self.published_at = Time.now
        end
      end
    end
  end
end
