class MissedItContent < ActiveRecord::Base
  include Concern::Methods::ContentSimpleJsonMethods

  self.table_name = "contentbase_misseditcontent"

  belongs_to :content,          polymorphic: true
  belongs_to :missed_it_bucket, foreign_key: "bucket_id"
  
  def obj_key
    content.obj_key if content.present?
  end
end
