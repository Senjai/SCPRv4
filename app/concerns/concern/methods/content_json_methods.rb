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
          :asset  => self.assets.present? ? self.assets.first.asset.lsquare.tag : nil,
          :byline => ApplicationUtility.render_byline(self,false)
        }
      end
    end # ContentJsonMethods
  end # Methods
end # Concern
