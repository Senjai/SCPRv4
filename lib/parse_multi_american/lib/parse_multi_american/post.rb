module WP
  module Post
    class Post < ActiveRecord::Base
      has_many :tagged_items, foreign_key: object_id, 
      has_many :tags, through: :tagged_items 
    end
  end
end
