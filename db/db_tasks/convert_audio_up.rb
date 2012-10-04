# Populate new Audio columns

errors    = 0
successes = 0

Audio.where("filename is null and store_dir is null").all.each do |audio|
  begin
    # If mp3 is present, use that to get the filename and store_dir
    if audio.django_mp3.present?
      path = audio.django_mp3.split("/")
      path.shift
      
      audio.filename  = path.pop
      audio.store_dir = path.join("/")
      
      # Carrierwave hijacks the mp3 accessor methods,
      # so we have to inject the string directly in as SQL
      ActiveRecord::Base.connection.execute("update #{Audio.table_name} set mp3='#{audio.filename}' where id=#{audio.id}")
      
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
        audio.store_dir = Audio::EncoAudio.store_dir(audio)
      end
    end

    audio.save!(validate: false)
    puts "Saved Audio ##{audio.id} as #{audio.type} with #{audio.path}"
    successes += 1
  rescue Exception => e
    puts "Error: #{e}"
    errors += 1
    next
  end
end

puts "Finished with #{errors} errors and #{successes} successes."
