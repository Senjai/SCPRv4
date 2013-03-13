class Related < ActiveRecord::Base
  self.table_name =  'media_related'

  map_content_type_for_django
  belongs_to :content, polymorphic: true, conditions: { status: ContentBase::STATUS_LIVE }
  belongs_to :related, polymorphic: true, conditions: { status: ContentBase::STATUS_LIVE }

  def simple_json
    {
      "id"       => self.related.try(:obj_key), # TODO Store this in join table
      "position" => self.position.to_i
    }
  end

  # Mapping for related content_type
  before_save :set_rel_django_content_type_id, on: :create, if: -> { self.rel_django_content_type_id.blank? }
  def set_rel_django_content_type_id
    if rails_class = RailsContentMap.find_by_rails_class_name(self.related_type)
      self.rel_django_content_type_id = rails_class.django_content_type_id
    end
  end

  default_scope where("content_type is not null and related_type is not null")
end
