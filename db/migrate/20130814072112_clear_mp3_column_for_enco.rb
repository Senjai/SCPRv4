class ClearMp3ColumnForEnco < ActiveRecord::Migration
  def up
    Audio::EncoAudio.update_all(mp3: nil)
  end

  def down
  end
end
