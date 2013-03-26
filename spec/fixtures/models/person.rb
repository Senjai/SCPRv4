module TestClass
  class Person < ActiveRecord::Base
    self.table_name = "test_class_people"
    
    include Concern::Validations::SlugValidation

    validates :twitter_url, url: { allow_blank: true, message: "bad url" } # Just allows any valid URL
  end
end
