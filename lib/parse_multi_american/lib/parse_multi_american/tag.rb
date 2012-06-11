module WP
  class Tag < ActiveRecord::Base
    self.table_name = "wp_tags"
    
    before_save :strip_cdata
    def strip_cdata
      stripped_name = MultiAmerican::Parser.strip_cdata(self.name)
      self.name = stripped_name || self.slug
    end
    
    after_save :add_tagged_item
    def add_tagged_item
      MultiAmerican::TaggedItem.create(tag_id: self.id, object_id: "", content_type_id: MultiAmerican::CONTENT_TYPE_ID)
    end
  end
end