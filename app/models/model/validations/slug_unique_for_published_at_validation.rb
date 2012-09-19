##
# SlugUniqueForPublishedAtValidation
# Add a uniqueness validation to slug,
# scoped to published_at
#
# Required fields: [:slug, :published_at, :status]
# Also requires object to respond to :should_validate?
#
module Model
  module Validations
    module SlugUniqueForPublishedAtValidation
      extend ActiveSupport::Concern

      include SlugValidation
      included do
        validates :slug, unique_by_date: { scope: :published_at, filter: :day, message: "has already been used for that publish date." },
          if: :should_validate?
        #
      end
    end
  end
end
