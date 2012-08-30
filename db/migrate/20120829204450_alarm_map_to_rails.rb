class AlarmMapToRails < ActiveRecord::Migration
  # Just for consistency
  KLASS = ContentAlarm
  
  def up
    KLASS.unscoped.all.each do |obj|
      begin
        rails_map = RailsContentMap.find_by_django_content_type_id!(obj.django_content_type_id)
        obj.update_attribute(:content_type, rails_map.rails_class_name)
        puts "Updated content_type for #{KLASS} ##{obj.id}"
      rescue ActiveRecord::RecordNotFound
        puts "Could not update content_type for #{KLASS} ##{obj.id} (No rails_class_name for django ID #{obj.django_content_type_id})"
      rescue Exception => e
        puts "An unexpected error occurred: #{e}"
      end
    end
  end

  def down
    KLASS.unscoped.update_all(content_type: nil)
  end
end
