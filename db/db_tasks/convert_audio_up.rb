# Populate new Audio columns

Audio.all.each do |audio|
  if audio.filename.blank? and audio.store_dir.blank? 
    # If mp3 is present, use that to get the filename and store_dir
    if audio[:mp3].present?
      path = audio[:mp3].split("/")
      path.shift
      audio.filename = path.pop
      audio.store_dir = path.join("/")
  
      if path[0] == "features"
        audio.type = "Audio::EncoAudio"
    
      elsif path[0] == "upload"
        audio.type = "Audio::UploadedAudio"
    
      elsif path[0] == "events"
        # Just incase this gets run after the event audio migration,
        # which will have already done this stuff
        break
      
      else
        audio.type = "Audio::ProgramAudio"
    
      end
    
    # Otherwise we have to guess based on enco info
    else
      if audio.enco_number.present?
        audio.type = "Audio::EncoAudio"
        audio.filename = Audio::EncoAudio.filename(audio)
        audio.store_dir = Audio::EncoAudio.store_dir
      end
    end
  
    audio.save
    puts "Saved Audio ##{audio.id} as #{audio.type} with #{audio.path}"
  end
end
