##
# AbstractModelMethods
#
# This does *not* have anything to do with class Abstract.
# It provides methods for the abstract models, like Article, Episode
#
# Requires that the class has an `original_object` object.
module Concern
  module Methods
    module AbstractModelMethods
      def cache_key
        original_object.cache_key if original_object.respond_to?(:cache_key)
      end

      def updated_at
        original_object.updated_at if original_object.respond_to?(:updated_at)
      end

      # Steal the ActiveRecord behavior for object comparison.
      # Compare Article ID with the comparison object's ID
      def ==(comparison_object)
        super ||
          comparison_object.instance_of?(self.class) &&
          self.id.present? &&
          self.id == comparison_object.id
      end
      alias :eql? :==
    end # AbstractModelMethods
  end # Methods
end # Concern
