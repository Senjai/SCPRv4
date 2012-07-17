module DjangoHelpers
  def map_content_type_for_django
    include InstanceMethods
    before_save :set_django_content_type_id, on: :create, if: -> { self.django_content_type_id.blank? }
  end
  
  module InstanceMethods
    def set_django_content_type_id
      self.django_content_type_id = RailsContentMap.find_by_class_name(self.content_type).id
    end
  end
end

ActiveRecord::Base.extend DjangoHelpers
