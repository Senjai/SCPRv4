module TestClass
  class RemoteStory < ActiveRecord::Base
    self.table_name = "test_class_remote_stories"
    
    include Concern::Validations::PublishedAtValidation
    include Concern::Validations::SlugValidation

    validates :remote_url, url: true
  end
end
