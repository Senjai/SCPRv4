class AddKpccProgramToRailsContentMap < ActiveRecord::Migration
  def up
    RailsContentMap.create django_content_type_id: 18, rails_class_name: "KpccProgram"
    RailsContentMap.create django_content_type_id: 12, rails_class_name: "OtherProgram"
  end
  
  def down
    RailsContentMap.delete_all(rails_class_name: "KpccProgram")
    RailsContentMap.delete_all(rails_class_name: "OtherProgram")
  end
end
