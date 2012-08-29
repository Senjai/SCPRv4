class AddModelsToRailsContentMap < ActiveRecord::Migration
  def up
    RailsContentMap.create django_content_type_id: 13, rails_class_name: "Bio"
    RailsContentMap.create django_content_type_id: 18, rails_class_name: "KpccProgram"
    RailsContentMap.create django_content_type_id: 12, rails_class_name: "OtherProgram"
    RailsContentMap.create django_content_type_id: 58, rails_class_name: "Homepage"
    
  end
  
  def down
    RailsContentMap.delete_all(rails_class_name: "Bio")
    RailsContentMap.delete_all(rails_class_name: "KpccProgram")
    RailsContentMap.delete_all(rails_class_name: "OtherProgram")
    RailsContentMap.delete_all(rails_class_name: "Homepage")
  end
end
