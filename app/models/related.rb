class Related < ActiveRecord::Base
  self.table_name =  'media_related'
  
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  belongs_to :related, polymorphic: true
  
  # Mapping for related content_type
  before_save :set_rel_django_content_type_id, on: :create, if: -> { self.rel_django_content_type_id.blank? }
  def set_rel_django_content_type_id
    self.rel_django_content_type_id = RailsContentMap.find_by_rails_class_name(self.related_type).django_content_type_id
  end
  
  FLAG_NORMAL = 0
  FLAG_TIEIN  = 1
  FLAG_UPDATE = 2
  
  FLAG_TEXT = {
      FLAG_NORMAL:  "Normal",
      FLAG_TIEIN:   "Tie-in",
      FLAG_UPDATE:  "Update"
  }

  default_scope where("content_type is not null and related_type is not null")
  scope :tiein,   -> { where(flag:         FLAG_TIEIN) }
  scope :updates, -> { where(flag:         FLAG_UPDATE) }
  scope :normal,  -> { where(flag:         FLAG_NORMAL) }
  scope :notiein, -> { where("flag != ?",  FLAG_TIEIN) }
  
  def self.sorted
    all().sort_by { |r| r.content.public_datetime }
  end
end
