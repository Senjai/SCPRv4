class RemoveNullRelated < ActiveRecord::Migration
  def up
    Related.where("content_type is null or related_type is null").each do |r|
      r.destroy
    end
  end

  def down
  end
end
