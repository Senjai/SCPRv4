##
# AbstractModelMethods
#
# This does *not* have anything to do with class Abstract.
# It provides methods for the abstract models, like Article, Episode
#
# Requires that the class has an `original_object` object
# and responds to `id`.
#
# Yes - the delegation kind of defeats the purpose of the abstract model.
# However, we should only delegate methods that are standard across all
# models, or most of them anyways, such as `updated_at` or `id`. We can
# be reasonably confident that most objects will respond to these common
# methods.
module Concern
  module Methods
    module AbstractModelMethods

      def public_path(*args)
        if original_object && original_object.respond_to?(:public_path)
          original_object.public_path(*args)
        end
      end

      def updated_at
        if original_object && original_object.respond_to?(:updated_at)
          original_object.updated_at
        end
      end

      def created_at
        if original_object && original_object.respond_to?(:created_at)
          original_object.created_at
        end
      end

      def cache_key
        if original_object && original_object.respond_to?(:cache_key)
          original_object.cache_key
        end
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
