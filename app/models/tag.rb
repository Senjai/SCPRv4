class Tag < ActiveRecord::Base
  self.table_name = "taggit_tag"
  
  # -------------------
  # Administration
  administrate
  
  # -------------------
  # Associations  
  has_many :tagged, :class_name => "TaggedContent"
  has_many :content, through: :tagged
end
