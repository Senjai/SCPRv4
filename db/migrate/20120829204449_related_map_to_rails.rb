class RelatedMapToRails < ActiveRecord::Migration  
  def up
    Related.unscoped.all.each do |obj|
      begin
        content_type = RailsContentMap.find_by_django_content_type_id!(obj.django_content_type_id)
        obj.update_attribute(:content_type, content_type.rails_class_name)
        puts "Updated content_type for Related ##{obj.id}"
      rescue
        puts "Could not update content_type for Related ##{obj.id}"
      end
      
      begin
        related_type = RailsContentMap.find_by_django_content_type_id!(obj.rel_django_content_type_id)
        obj.update_attribute(:related_type, related_type.rails_class_name)
        puts "Updated related_type for Related ##{obj.id}"
      rescue
        puts "Could not update related_type for Related ##{obj.id}"
      end
    end
  end

  def down
    Related.unscoped.update_all(content_type: nil, related_type: nil)
  end
end
