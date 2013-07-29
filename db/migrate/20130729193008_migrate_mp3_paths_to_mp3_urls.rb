class MigrateMp3PathsToMp3Urls < ActiveRecord::Migration
  def up
    Audio::DirectAudio.all.each do |audio|
      path = audio.external_url
      audio.update_column :external_url, File.join(Audio::AUDIO_URL_ROOT, path.gsub(/\A(audio)/, ""))
      audio.update_column :mp3, nil
    end
  end

  def down
  end
end
