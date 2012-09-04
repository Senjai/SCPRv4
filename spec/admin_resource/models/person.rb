class Person
  extend AdminResource::Administrate
  
  attr_accessor :name, :email, :location, :age
  
  administrate do |admin|
    admin.define_list do |list|
      list.column "name"
      list.column "email"
      list.column "location"
      list.column "age"
    end
  end
end
