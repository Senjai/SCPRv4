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
# methods - however, Rails' `delegate` method also checks to make sure
# the object will respond to the method.
module Concern
  module Methods
    module AbstractModelMethods
      extend ActiveSupport::Concern

      included do
        delegate \
          :public_path,
          :updated_at,
          :created_at,
          :cache_key,
          to: :original_object
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
