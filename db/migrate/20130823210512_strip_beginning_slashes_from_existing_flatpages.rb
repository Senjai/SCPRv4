class StripBeginningSlashesFromExistingFlatpages < ActiveRecord::Migration
  def up
    Flatpage.all.each do |flatpage|
      flatpage.update_column(:path, flatpage.path.gsub(/\A\//, "").gsub(/\/\z/, ""))
    end
  end

  def down
    Flatpage.all.each do |flatpage|
      flatpage.update_column(:path, "/#{flatpage.path}/")
    end
  end
end
