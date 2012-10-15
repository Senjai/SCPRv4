##
# SlugValidation
# Basic validation for slug field
#
# Required fields: [:slug]
# Also requires object to respond to :should_validate?
#
module Model
  module Validations
    module SlugValidation
      extend ActiveSupport::Concern

      included do
        validates :slug,
          presence: true, # Mostly just for tests
          format: { with: Validations::DEFAULTS[:slug_format] },
          length: { maximum: 50 },
          if: :should_validate?
      end
    end
  end
end
