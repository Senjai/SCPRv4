class PopulateAudioPath < ActiveRecord::Migration
  def up
    Audio.where("mp3 is not null and path is null").find_in_batches do |group|
      group.each do |a|
        a.update_column(:path, File.join(a.store_dir, a.send(:read_attribute, :mp3)))
      end
    end
  end

  def down
    Audio.update_all(path: nil)
  end
end
