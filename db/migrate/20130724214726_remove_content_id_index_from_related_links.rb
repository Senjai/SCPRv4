class RemoveContentIdIndexFromRelatedLinks < ActiveRecord::Migration
  def change
    remove_index :related_links, :name => "media_link_content_type_id_41947a9a86b99b7a"
  end
end
