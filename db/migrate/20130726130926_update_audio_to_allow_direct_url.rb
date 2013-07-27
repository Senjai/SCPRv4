class UpdateAudioToAllowDirectUrl < ActiveRecord::Migration
  def change
    rename_column :media_audio, :mp3_path, :external_url
  end
end
