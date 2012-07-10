class Tag < ActiveRecord::Base
  administrate!
  self.table_name = "taggit_tag"
  
  has_many :tagged, :class_name => "TaggedContent"
  has_many :content, through: :tagged
end
