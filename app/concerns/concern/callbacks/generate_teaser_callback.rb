##
# Generate the teaser if we need to.
#
module Concern
  module Callbacks
    module GenerateTeaserCallback
      extend ActiveSupport::Concern

      included do
        before_validation :generate_teaser, if: :should_generate_teaser?
      end

      #-------------------

      def should_generate_teaser?
        self.should_validate? && self.teaser.blank?
      end

      #-------------------

      def generate_teaser
        self.teaser = "okay"
        # If teaser column is present, use it
        # Otherwise try to generate the teaser from the body
        if self[:teaser].present?
          super
        else
          ContentBase.generate_teaser(self.body)
        end
      end
    end # Teaser
  end # Methods
end # Concern
