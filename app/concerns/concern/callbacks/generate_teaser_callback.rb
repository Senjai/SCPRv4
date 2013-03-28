##
# Generate a teaser from body if it's blank.
#
module Concern
  module Callbacks
    module GenerateTeaserCallback
      extend ActiveSupport::Concern

      included do
        before_validation :generate_teaser, if: :should_generate_teaser?
      end

      def should_generate_teaser?
        self.should_validate? && self.teaser.blank?
      end

      def generate_teaser
        if self.body.present?
          self.teaser = ContentBase.generate_teaser(self.body, 180)
        end
      end
    end
  end
end
