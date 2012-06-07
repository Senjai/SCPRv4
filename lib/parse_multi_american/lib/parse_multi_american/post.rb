module MultiAmerican
  class Post < ActiveRecord::Base
    self.table_name = "blogs_entry"
    has_many :tagged_items, foreign_key: object_id, 
    has_many :tags, through: :tagged_items 
  end
end
