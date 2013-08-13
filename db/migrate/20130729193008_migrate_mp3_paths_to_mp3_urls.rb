class MigrateMp3PathsToMp3Urls < ActiveRecord::Migration
  def up
    Audio::DirectAudio.all.each do |audio|
      path = audio.external_url
      audio.update_column :external_url, File.join("http://media.scpr.org/audio/", path.gsub(/\A(audio)/, ""))
      audio.update_column :mp3, nil
    end
  end

  def down
  end
end
