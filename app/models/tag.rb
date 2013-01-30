class Tag < ActiveRecord::Base
  self.table_name = "taggit_tag"
  
  # -------------------
  # Associations
  has_many :tagged, class_name: "TaggedContent"
  has_many :content, through: :tagged
end
