class Person
  extend AdminResource::Administrate
  include AdminResource::Helpers::Model
  
  attr_accessor :id, :name, :email, :location, :age
  
  def initialize(attributes={})
    attributes.each do |attrib, val|
      send("#{attrib}=", val)
    end
  end
  
  administrate do |admin|
    admin.define_list do |list|
      list.column "name"
      list.column "email"
      list.column "location"
      list.column "age"
    end
  end
end
