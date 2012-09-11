module DjangoHelpers
  module Base
    def map_content_type_for_django
      include InstanceMethods
      default_scope where("content_type is not null")
      before_save :set_django_content_type_id, on: :create, if: -> { self.django_content_type_id.blank? }
    end

    module InstanceMethods
      def set_django_content_type_id
        # This will set NULL if the content type has been removed from the mapping table, which is what we want
        self.django_content_type_id = RailsContentMap.find_by_rails_class_name(self.content_type).try(:django_content_type_id)
      end
    end
  end
end
