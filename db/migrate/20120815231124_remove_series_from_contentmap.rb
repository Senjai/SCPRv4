class RemoveSeriesFromContentmap < ActiveRecord::Migration
  def up
    RailsContentMap.find_by_rails_class_name("ShowSeries").delete
  end

  def down
    RailsContentMap.create(django_content_type_id: 51, rails_class_name: "ShowSeries")
  end
end
