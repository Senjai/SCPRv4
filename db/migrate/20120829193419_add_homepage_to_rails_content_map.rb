class AddHomepageToRailsContentMap < ActiveRecord::Migration
  def up
    RailsContentMap.create django_content_type_id: 58, rails_class_name: "Homepage"
  end
  
  def down
    RailsContentMap.delete_all(rails_class_name: "Homepage")
  end
end
