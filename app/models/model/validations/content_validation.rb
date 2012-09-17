##
# ContentValidation
# Basic validations for all content
#
# Required fields: [:headline, :body, :status]
# Also requires that the object responds to :should_validate?
#
module Model
  module Validations
    module ContentValidation
      extend ActiveSupport::Concern

      included do
        validates_presence_of :headline  # always
        validates_presence_of :body,     if: :should_validate?
        validates_presence_of :status    # always
      end
    end
  end
end
