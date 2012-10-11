class ConvertEventAudio < ActiveRecord::Migration
  def up
    # Take all Event audio and convert it to real Audio::DirectAudio objects
    # A syncing process will have to them pick them up to generate the mp3 info

    Event.where("old_audio != ''").each do |event|
      audio = Audio::DirectAudio.new(content: event, byline: "", mp3_path: event.old_audio.gsub(/^audio\//, ""), description: event.headline)
      audio.save!
      puts "Saved Audio ##{audio.id} for Event ##{event.id}"
    end
    
    Audio::DirectAudio.sync!
  end

  def down
    Audio.delete_all(content_type: "Event")
  end
end
