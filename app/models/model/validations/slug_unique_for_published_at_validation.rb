##
# SlugUniqueForPublishedAtValidation
# Add a uniqueness validation to slug,
# scoped to published_at
#
# Required fields: [:slug, :published_at, :status]
#
module Model
  module Validations
    module SlugUniqueForPublishedAtValidation
      extend ActiveSupport::Concern

      include SlugValidation
      included do
        validates_uniqueness_of :slug, 
          scope: :published_at, 
          message: "has already been used for that publish date.",
          if: -> { self.publishing? }
        #
      end
    end
  end
end
