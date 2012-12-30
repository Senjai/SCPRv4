##
# GeneraterSlugCallback
#
# Generates a slug if it's blank.
# Required fields: [:slug, :headline]
#
module Concern
  module Callbacks
    module GenerateSlugCallback
      extend ActiveSupport::Concern
      
      included do
        before_validation :generate_slug, on: :create, if: -> { self.slug.blank? }
      end
      
      #--------------------
      
      def generate_slug
        if self.headline.present?
          self.slug = self.headline.parameterize[0...50].sub(/-+\z/, "")
        end
      end
    end
  end
end
