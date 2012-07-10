class TaggedContent < ActiveRecord::Base
  self.table_name = "taggit_taggeditem"
  
  belongs_to :tag
  belongs_to :content, :polymorphic => true
  
  before_save :setup_mercer_attributes
  
  # Hard-code for now...
  def setup_mercer_attributes
    self.content_type_id = "44"
  end
end
