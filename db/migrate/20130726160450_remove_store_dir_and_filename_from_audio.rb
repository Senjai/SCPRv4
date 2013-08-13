class RemoveStoreDirAndFilenameFromAudio < ActiveRecord::Migration
  def up
    remove_column :media_audio, :store_dir
    remove_column :media_audio, :filename
  end

  def down
    add_column :media_audio, :store_dir, :string
    add_column :media_audio, :filename, :string
  end
end
