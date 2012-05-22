class UpdateEventsFlatpagePaths < ActiveRecord::Migration
  def up
    Flatpage.unscoped.where("url LIKE ?", "/forum%").all.each do |flatpage|
      flatpage.update_attributes(url: "/events#{flatpage.url}", enable_in_new_site: true)
    end
  end

  def down
    Flatpage.unscoped.where("url LIKE ?", "/events%").all.each do |flatpage|
      flatpage.update_attributes(url: flatpage.url.gsub("/events", ""), enable_in_new_site: false)
    end
  end
end
