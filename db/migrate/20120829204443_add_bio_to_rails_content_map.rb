class AddBioToRailsContentMap < ActiveRecord::Migration
  def up
    RailsContentMap.create django_content_type_id: 13, rails_class_name: "Bio"
  end
  
  def down
    RailsContentMap.delete_all(rails_class_name: "Bio")
  end
end
