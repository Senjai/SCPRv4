class TaggedContent < ActiveRecord::Base
  self.table_name = "taggit_taggeditem"
  
  belongs_to :tag
  belongs_to :content, :polymorphic => true
  
  before_save :setup_mercer_attributes
    
  def setup_mercer_attributes
    self.content_type_id = RailsContentMap.find_by_class_name(self.content_type).try(:id)
  end
end
