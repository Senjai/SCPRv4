##
# ContentValidation
# Basic validations for all content
#
# Required fields: [:headline, :body, :status]
# Also requires that the object responds to :should_validate?
#
module Concern
  module Validations
    module ContentValidation
      extend ActiveSupport::Concern
      BODY_MESSAGE = "can't be blank <br />when publishing"
      
      included do
        validates_presence_of :headline  # always
        validates_presence_of :body,     message: BODY_MESSAGE, if: :should_validate?
        validates_presence_of :status    # always
      end
    end # ContentValidation
  end # Validations
end # Concern
