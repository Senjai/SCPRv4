module TestClass
  class PostContent < ActiveRecord::Base
    include Concern::Methods::ContentSimpleJsonMethods
    self.table_name = "test_class_post_contents"

    belongs_to :content, polymorphic: true
  end
end
