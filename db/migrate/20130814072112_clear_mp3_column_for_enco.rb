class ClearMp3ColumnForEnco < ActiveRecord::Migration
  def up
    Audio::EncoAudio.find_in_batches do |group|
      group.each do |audio|
        audio.update_column(:mp3, nil)
      end
    end
  end

  def down
  end
end
