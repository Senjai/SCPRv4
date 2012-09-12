class Person < ActiveRecord::Base  
  attr_accessible :name, :email, :location, :age
  
  administrate do |admin|
    admin.define_list do |list|
      list.column "name"
      list.column "email"
      list.column "location"
      list.column "age"
    end
  end
end
