class ChangePressReleaseColumns < ActiveRecord::Migration
  def change
    rename_table :press_releases_release, :press_releases
    
    change_table :press_releases do |t|
      t.timestamps
      t.change :short_title, :string
      t.change :slug, :string
      t.change :long_title, :string
      t.change :body, :text
    end
    
    PressRelease.all.each do |release|
      release.update_column(:created_at, release.published_at)
    end
    
    drop_column :press_releases, :published_at
  end
end
