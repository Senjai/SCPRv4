class ContentCategoryMapToRails < ActiveRecord::Migration
  KLASS = ContentCategory
  
  def up
    KLASS.unscoped.all.each do |obj|
      begin
        rails_map = RailsContentMap.find_by_django_content_type_id!(obj.django_content_type_id)
        obj.update_attribute(:content_type, rails_map.rails_class_name)
        puts "Updated content_type for #{KLASS} ##{obj.id}"
      rescue
        puts "Could not update content_type for #{KLASS} ##{obj.id}"
      end
    end
  end

  def down
    KLASS.unscoped.update_all(content_type: nil)
  end
end
