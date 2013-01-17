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
          :asset  => self.primary_asset(:lsquare),
          :byline => self.byline
        }
      end
    end # ContentJsonMethods
  end # Methods
end # Concern
