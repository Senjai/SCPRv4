module TestClass
  class PostContent < ActiveRecord::Base
    include Outpost::Aggregator::SimpleJson

    self.table_name = "test_class_post_contents"

    belongs_to :content, polymorphic: true
  end
end
