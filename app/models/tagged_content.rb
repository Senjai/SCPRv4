class TaggedContent < ActiveRecord::Base
  self.table_name = "taggit_taggeditem"
  
  belongs_to :tag
  belongs_to :content, :polymorphic => true
  
  before_save :setup_mercer_attributes
  
  # Hard-code for now...
  def setup_mercer_attributes
    self.django_content_type_id = BlogEntry::CONTENT_TYPE_ID
  end
end
