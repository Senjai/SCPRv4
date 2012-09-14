##
# SlugValidation
# Basic validation for slug field
#
# Required fields: [:slug]
#
module Model
  module Validations
    module SlugValidation
      extend ActiveSupport::Concern

      included do
        validates :slug,
          presence:   true,
          format:     { with: Validations::DEFAULTS[:slug_format] }
        #
      end
    end
  end
end
