class MissedItContent < ActiveRecord::Base
  self.table_name = "contentbase_misseditcontent"

  map_content_type_for_django
  belongs_to :content,          polymorphic: true  
  belongs_to :missed_it_bucket, foreign_key: "bucket_id"
  
  def obj_key
    content.obj_key if content.present?
  end
end