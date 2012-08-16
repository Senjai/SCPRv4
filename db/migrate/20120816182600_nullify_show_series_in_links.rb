class NullifyShowSeriesInLinks < ActiveRecord::Migration
  def up
    Link.unscoped.where(content_type: "ShowSeries").all.each do |link|
      link.update_attribute(:content_type, nil)
      puts "Updated content_type for Link ##{link.id}"
    end
  end

  def down
    Link.unscoped.where(django_content_type_id: 51).all.each do |link|
      link.update_attribute(:content_type, "ShowSeries")
      puts "Updated content_type for Link ##{link.id}"
    end
  end
end
