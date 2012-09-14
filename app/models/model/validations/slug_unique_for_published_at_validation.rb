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
        # TODO: The editor should be aware of validation failures before publish
        # Auto-publishing should never fail validation.
        validates :slug, unique_by_date: { scope: :published_at, filter: :day, message: "has already been used for that publish date." },
          if: :published?
        #

      end
    end
  end
end
