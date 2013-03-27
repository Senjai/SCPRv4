class RemoveBadRelatedLinks < ActiveRecord::Migration
  def up
    RelatedLink.where("content_type is null").each do |r|
      r.destroy
    end
  end

  def down
  end
end
