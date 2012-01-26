class Tag < ActiveRecord::Base
  self.table_name = "taggit_tag"
  
  has_many :tagged, :class_name => "TaggedContent"
end