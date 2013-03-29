##
# Generate a short_headline if it's blank.
#
module Concern
  module Callbacks
    module GenerateShortHeadlineCallback
      extend ActiveSupport::Concern

      included do
        before_validation :generate_short_headline, if: :should_generate_short_headline?
      end

      def should_generate_short_headline?
        self.should_validate? && self.short_headline.blank?
      end

      def generate_short_headline
        if self.headline.present?
          self.short_headline = self.headline
        end
      end
    end
  end
end
