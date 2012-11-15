module TestClass
  class Person < ActiveRecord::Base
    self.table_name = "test_class_people"
    
    include Concern::Validations::SlugValidation
  end
end
