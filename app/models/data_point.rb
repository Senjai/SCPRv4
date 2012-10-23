##
# DataPoint
#
# A terribly-named model for storing arbitrary data 
# as key/value pairs. Like Redis but slower. :)
# 
# Group pairs with the "group" column. The group column
# is just an arbitrary string and isn't tied to any other
# models. This makes it possible to grab related data with 
# only one query:
#
#   @data_points = DataPoint.where(group: "election2012")
#
# A DataPoint should be added in production *before* anything
# is deployed that relies on that key.
# Don't assume the key will be there!
#
class DataPoint < ActiveRecord::Base  
  has_secretary
  
  #--------------
  # Administration
  administrate do
    define_list do
      order    = "group, data_key"
      per_page = :all
      
      column :group
      column :data_key, linked: true
      column :description
    end
  end

  
  #--------------
  # Scopes
  
  
  #--------------
  # Validation
  validates :data_key, presence: true, uniqueness: true
  
  
  #--------------
  # Association
  
  
  class << self
    def to_hash(collection)
      hash = {}
      collection.each { |obj| hash[obj.data_key] = obj.data }
      hash
    end
  end
end
