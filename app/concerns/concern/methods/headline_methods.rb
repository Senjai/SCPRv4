##
# HeadlineMethods
#
# Methods for figuring out what to display
# if the short_headline attribue is missing
#
# Ideally, we should just require a short_headline
# on every article.
#
module Concern
  module Methods
    module HeadlineMethods
      def short_headline
        if self[:short_headline].present?
          super
        else
          self.headline
        end
      end
    end # HeadlineMethods
  end # Methods
end # Concern
