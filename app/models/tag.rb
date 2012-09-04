class Tag < ActiveRecord::Base
  self.table_name = "taggit_tag"
  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order = "name"
      list.column "name"
      list.column "slug"
    end
  end
  
  # -------------------
  # Associations  
  has_many :tagged, :class_name => "TaggedContent"
  has_many :content, through: :tagged
end
