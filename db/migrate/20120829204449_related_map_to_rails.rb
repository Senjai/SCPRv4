class RelatedMapToRails < ActiveRecord::Migration
  KLASS = Related
  
  def up
    KLASS.unscoped.all.each do |obj|
      begin
        content_type = RailsContentMap.find_by_django_content_type_id!(obj.django_content_type_id)
        obj.update_attribute(:content_type, content_type.rails_class_name)
        puts "Updated content_type for Related ##{obj.id}"
      rescue ActiveRecord::RecordNotFound
        puts "Could not update content_type for #{KLASS} ##{obj.id} (No rails_class_name for django ID #{obj.django_content_type_id})"
      rescue Exception => e
        puts "An unexpected error occurred: #{e}"
      end
      
      begin
        related_type = RailsContentMap.find_by_django_content_type_id!(obj.rel_django_content_type_id)
        obj.update_attribute(:related_type, related_type.rails_class_name)
        puts "Updated related_type for Related ##{obj.id}"
      rescue ActiveRecord::RecordNotFound
        puts "Could not update related_type for #{KLASS} ##{obj.id} (No rails_class_name for django ID #{obj.django_content_type_id})"
      rescue Exception => e
        puts "An unexpected error occurred: #{e}"
      end
    end
  end

  def down
    KLASS.unscoped.update_all(content_type: nil, related_type: nil)
  end
end
