class Person < ActiveRecord::Base
  attr_accessible :name, :email, :location, :age
  ROUTE_KEY = "people"
  
  administrate do    
    define_list do
      column "name"
      column "email"
      column "location"
      column "age"
    end
  end
  
  def route_hash
    {
      :id   => self.id,
      :slug => self.name.parameterize
    }
  end
end
