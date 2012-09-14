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
