##
# ContentJsonMethods
#
# Temporary mixin for asset and byline in json
#
module Concern
  module Methods
    module ContentJsonMethods
      def json
        {
          :asset  => self.asset.present? ? self.asset.lsquare.tag : nil,
          :byline => self.byline
        }
      end
    end # ContentJsonMethods
  end # Methods
end # Concern
