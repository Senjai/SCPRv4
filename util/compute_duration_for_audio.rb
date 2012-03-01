# run through script/runner

require 'mp3info'

[EncoAudio,ProgramAudio,UploadedAudio].each do |model|
  puts "Starting #{model}"
  model.where(:duration => nil).each do |audio|

    if File.exists?(audio.mp3_path)
      begin 
        Mp3Info.open(audio.mp3_path) do |mp3|
          audio.duration = mp3.length
          audio.save()
        end     
      rescue
        puts "Failed to parse file: #{audio.class}/#{audio.id} -- #{audio.mp3_path}"
      end   
    else
      puts "Not Found: #{audio.class}/#{audio.id} -- #{audio.mp3_path}"    end 
  end
end