##
# ContentValidation
# Basic validations for all content
#
# Required fields: [:headline, :body, :status]
#
module Model
  module Validations
    module ContentValidation
      extend ActiveSupport::Concern

      included do
        validates_presence_of :headline, if: -> { self.published? }
        validates_presence_of :body,     if: -> { self.published? }
        validates_presence_of :status
        
        def publishing?
           self.status_changed? and self.published?
        end
      end
    end
  end
end
