# run through script/runner

require 'mp3info'

Audio.available.each do |audio|
  if File.exists?(audio.mp3_path)
    File.open(audio.mp3_path) do |f|
      audio.size = f.size     
      audio.save              
    end               
  else
    puts "Not Found: #{audio.class}/#{audio.id} -- #{audio.mp3_path}"
    audio.size = 0
    audio.save        
  end 
end
