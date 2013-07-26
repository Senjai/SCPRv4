class UpdateAudioToAllowDirectUrl < ActiveRecord::Migration
  def up
    rename_column :media_audio, :mp3_path, :mp3_url
  end

  def down
    rename_column :media_audio, :mp3_url, :mp3_path
  end
end
