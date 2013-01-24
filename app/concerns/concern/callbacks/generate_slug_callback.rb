##
# GeneraterSlugCallback
#
# Generates a slug if it's blank.
# Required attributes: [:slug, :headline]
#
module Concern
  module Callbacks
    module GenerateSlugCallback
      extend ActiveSupport::Concern
      
      included do
        before_validation :generate_slug, if: :should_generate_slug?
      end

      #--------------------
      # When to generate the slug.
      # Override this if you want to control when it happens.
      def should_generate_slug?
        self.slug.blank?
      end
      
      #--------------------
      # Generate the slug if the headline is present.
      # Also strips trailing hyphens.
      def generate_slug
        if self.headline.present?
          self.slug = self.headline.parameterize[0...50].sub(/-+\z/, "")
        end
      end
    end
  end
end
