class TaggedContent < ActiveRecord::Base
  self.table_name = "rails_taggit_taggeditem"
  
  belongs_to :tag
  belongs_to :content, :polymorphic => true
end