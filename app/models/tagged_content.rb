class TaggedContent < ActiveRecord::Base
  self.table_name = "taggit_taggeditem"

  belongs_to :content, polymorphic: true
  belongs_to :tag
end
