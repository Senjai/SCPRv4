class RenameFlatpageFields < ActiveRecord::Migration
  def up
    rename_column :flatpages_flatpage, :url, :path
    change_column :flatpages_flatpage, :path, :string
    change_column :flatpages_flatpage, :title, :string
    change_column :flatpages_flatpage, :template, :string

    rename_column :flatpages_flatpage, :redirect_url, :redirect_to
    change_column :flatpages_flatpage, :redirect_to, :string
  end

  def down
    rename_column :flatpages_flatpage, :redirect_to, :redirect_url
    rename_column :flatpages_flatpage, :path, :url
  end
end
