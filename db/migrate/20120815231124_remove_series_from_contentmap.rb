class RemoveSeriesFromContentmap < ActiveRecord::Migration
  def up
    RailsContentMap.delete_all(rails_class_name: "ShowSeries")
  end

  def down
    RailsContentMap.create(django_content_type_id: 51, rails_class_name: "ShowSeries")
  end
end
