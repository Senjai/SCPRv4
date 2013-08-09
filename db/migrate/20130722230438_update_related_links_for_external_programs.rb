class UpdateRelatedLinksForExternalPrograms < ActiveRecord::Migration
  def up
    RelatedLink.where(content_type: "OtherProgram").update_all(content_type: "ExternalProgram")
  end

  def down
    RelatedLink.where(content_type: "ExternalProgram").update_all(content_type: "OtherProgram")
  end
end
