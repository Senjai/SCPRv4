##
# PublishedAtValidation
# Basic validation for published_at
#
# This module should not be included in models
# which will have their published_at attribute
# automatically updated. It's for models where
# the published_at attribute needs to be manually
# inserted, such as ContentShell and VideoShell.
#
# Required attributes: [:published_at]
# Also requires object to respond to :should_validate?
#
module Concern
  module Validations
    module PublishedAtValidation
      extend ActiveSupport::Concern

      included do
        validates :published_at, presence: true, if: :should_validate?
      end
    end # PublishedAtValidation
  end # Validations
end # Concern
