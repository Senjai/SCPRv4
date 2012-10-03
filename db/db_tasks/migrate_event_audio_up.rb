# Take all Event audio and convert it to real Audio::DirectAudio objects
# A syncing process will have to them pick them up to generate the mp3 info

Event.where("old_audio != ''").each do |event|
  if File.exists? File.join Rails.application.config.scpr.media_root, event.old_audio
    audio = Audio::DirectAudio.new(content: event, mp3_path: event.old_audio.gsub(/^audio\//, ""))
    audio.save
    puts "Saved Audio ##{audio.id} for Event ##{event.id}"
  else
    puts "File not found for Event ##{event.id} (#{event.old_audio})"
  end
end
