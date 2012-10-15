class Tag < ActiveRecord::Base
  self.table_name = "taggit_tag"
  
  # -------------------
  # Administration
  administrate do
    define_list do
      order = "name"
      column "name"
      column "slug"
    end
  end
  
  # -------------------
  # Associations  
  has_many :tagged, :class_name => "TaggedContent"
  has_many :content, through: :tagged
end
