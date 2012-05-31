output = "39162 Debra Baer
39168 Katherine Butler
39171 Bill Davis
39172 Brian De Los Santos
39174 Gina Delvac
39175 Cheryl Devall
39176 Kitty Felde
39179 Don Frances
39181 Jason Georges
39186 Shirley Jahad
39187 Siel Ju
39189 Jason Kandel
39190 Queena Kim
39191 Mark Lacter
39193 Jeffrey Long
39199 Shereen Marisol Meraji
39200 Kathleen Miles
39201 Corey Moore
39202 Julio Morales
39203 Kari Moran
39205 Kristen Muller
39206 Patricia Nazario
39207 Arwen Nicks
39208 Kim Nowacki
39210 Jackie Oclaray
39212 Linda Othenin-Girard
39213 James Panetta
39214 Rita  Pardue
39216 Brooke Peterson
39217 Tony Pierce
39220 Bianca Ramirez
39221 Mike Roe
39225 Samantha Schaefer
39227 Jonathan Serviss
39230 Julie Small
39231 Russ Stanton
39233 Rob Strauss
39235 Susan Valot"

lines = output.split("\n")
puts "Records: #{lines.size}"

lines.each do |line|
  arr = line.split(" ", 2)
  asset_id = arr[0]
  name = arr[1]
  if bio = Bio.find_by_name(name)
    if bio.asset_id == 0
      if bio.update_attribute(:asset_id, asset_id)
        puts "saved: #{asset_id} for #{bio.name}"
      else
        puts "failed: #{bio.name}"
      end
    else
      puts "failed: #{bio.name} already has asset_id (#{bio.asset_id})"
    end
  else
    puts "failed: Missed bio for #{name}"
  end
end
  
puts "Done!"
