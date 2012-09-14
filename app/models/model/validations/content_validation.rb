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
        validates_presence_of :headline, if: :should_validate?
        validates_presence_of :body,     if: :should_validate?
        validates_presence_of :status
        
        def should_validate?
          pending? or published?
        end
      end
    end
  end
end
