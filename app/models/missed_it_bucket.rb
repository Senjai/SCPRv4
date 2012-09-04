class MissedItBucket < ActiveRecord::Base
  self.table_name = "contentbase_misseditbucket"
  
  #-----------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.column "id"
      list.column "title", linked: true
    end
  end
  
  #-----------
  # Association
  has_many :contents, class_name: "MissedItContent", foreign_key: "bucket_id", order: "position asc"
  
  def obj_key
    "missed_it:#{id}"
  end
end
