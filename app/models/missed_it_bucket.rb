class MissedItBucket < ActiveRecord::Base
  self.table_name = "contentbase_misseditbucket"
  has_many :contents, class_name: "MissedItContent", foreign_key: "bucket_id", order: "position asc"
  
  def obj_key
    "missed_it:#{id}"
  end
end
