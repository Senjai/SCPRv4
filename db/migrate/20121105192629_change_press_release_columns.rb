class ChangePressReleaseColumns < ActiveRecord::Migration
  def change
    rename_table :press_releases_release, :press_releases
    
    change_table :press_releases do |t|
      t.timestamps
      t.change :short_title, :string, null: true, default: nil
      t.change :slug, :string, null: true, default: nil
      t.change :long_title, :string, null: true, default: nil
      t.rename :long_title, :title
      t.change :body, :text, default: ""
    end
    
    PressRelease.all.each do |release|
      release.update_attributes(:created_at => release.published_at, :updated_at => release.published_at)
    end
    
    remove_column :press_releases, :published_at
  end
end
