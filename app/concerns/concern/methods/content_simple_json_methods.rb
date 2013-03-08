##
# ContentSimpleJsonMethods
#
# Provides a standard simple_json method to be applied to
# join models between an object and content.
# 
# This is for Aggregator compatibility mostly. Should be kept
# in sync with ContentAPI#simpleJSON
module Concern
  module Methods
    module ContentSimpleJsonMethods
      #---------------------
      # For the aggregator
      # Keep this in sync with ContentAPI's simpleJSON method
      def simple_json
        {
          "id"       => self.id,
          "position" => self.position.to_i
        }
      end
    end # ContentSimpleJsonMethods
  end # Methods
end # Concern
