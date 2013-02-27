##
# DataPoint
#
# A terribly-named model for storing arbitrary data 
# as key/value pairs. Like Redis but slower. :)
# 
# Group pairs with the "group_name" column. The group_name
# column is just an arbitrary string and isn't tied to any 
# other models. This makes it possible to grab related data 
# with only one query:
#
#   @data_points = DataPoint.where(group_name: "election2012")
#
# A DataPoint should be added in production *before* anything
# is deployed that relies on that key.
# Don't assume the key will be there!
#
class DataPoint < ActiveRecord::Base
  outpost_model
  has_secretary
  
  #--------------
  # Scopes
  
  #--------------
  # Association
  
  #--------------
  # Validation
  validates :data_key, presence: true, uniqueness: true
  
  #--------------
  # Callbacks

  #--------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes data_key, sortable: true
    indexes data_value
    indexes group_name, sortable: true
    has updated_at
  end
  
  #--------------
  
  class << self
    # DataPoint::to_hash lets us take an array and turn it into
    # a hash, where the data_key is the key and the data_value
    # is the value. 
    #
    # ...Why?
    #
    # Because otherwise we would have to use Ruby's Enumerable#find 
    # everywhere, which is a lot slower than a hash. Also, the DataPoint
    # model is modeled after a Hash - a key, and a value - so it makes
    # sense to turn it into a real hash.
    #
    def to_hash(collection)
      hash = {}
      collection.each { |obj| hash[obj.data_key] = DataPoint::Hashed.new(obj) }
      hash
    end

    #--------------

    def group_names_select_collection
      DataPoint.select("distinct group_name").order("group_name").map(&:group_name)
    end
  end

  #--------------
  
  def json
    {
      :group_name => self.group_name,
      :data_key   => self.data_key,
      :data_value => self.data_value
    }
  end
  
  #--------------
  # DataPoint::Hashed
  #
  class Hashed
    delegate :data_value, :data_key, to: :@object
    
    attr_accessor :object
    def initialize(object)
      @object = object
    end
    
    #----------
    
    def to_s
      @object.data_value
    end
    
    #----------
    
    def ==(val)
      self.to_s == val
    end
  end
end
