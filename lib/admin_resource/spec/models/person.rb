class Person < ActiveRecord::Base
  attr_accessible :name, :email, :location, :age
  ROUTE_KEY = "people"
  
  administrate do |admin|    
    admin.define_list do |list|
      list.column "name"
      list.column "email"
      list.column "location"
      list.column "age"
    end
  end
  
  def route_hash
    {
      :id   => self.id,
      :slug => self.name.parameterize
    }
  end
end
