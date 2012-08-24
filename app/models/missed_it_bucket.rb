class MissedItBucket < ActiveRecord::Base
  self.table_name = "contentbase_misseditbucket"
  
  #-----------
  # Administration
  administrate
  self.list_fields = [
    ["id"],
    ["title", link: true]
  ]
  
  #-----------
  # Association
  has_many :contents, class_name: "MissedItContent", foreign_key: "bucket_id", order: "position asc"
  
  def obj_key
    "missed_it:#{id}"
  end
end
