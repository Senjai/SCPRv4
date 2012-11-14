##
# TeaserMethods
#
# Displaying teaser
#
module Concern
  module Methods
    module TeaserMethods
      def teaser
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
