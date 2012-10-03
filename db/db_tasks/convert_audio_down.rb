# Revert the population of new Audio columns

Audio.all.each do |audio|
  audio.type      = nil
  audio.filename  = nil
  audio.store_dir = nil
  audio.save
  puts "Reverted Audio ##{audio.id}"
end
