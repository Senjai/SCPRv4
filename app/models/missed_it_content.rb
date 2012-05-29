class MissedItContent < ActiveRecord::Base
  self.table_name = "rails_contentbase_misseditcontent"
  
  belongs_to :missed_it_bucket, foreign_key: "bucket_id"
  belongs_to :content, polymorphic: true
  
  def obj_key
    content.obj_key if content.present?
  end
end