output = "39160 Tami Abdollah
39161 Erika Aguilar
39162 Debra Baer
39163 Ashley Bailey
39164 Leslie Berestein Rojas
39165 Madeleine Brand
39166 Lisa Brenner
39167 Kim Bui
39168 Katherine Butler
39169 Alex Cohen
39170 Noelle Conti
39171 Bill Davis
39172 Brian De Los Santos
39173 Matthew DeBord
39174 Gina Delvac
39175 Cheryl Devall
39176 Kitty Felde
39177 Kevin Ferguson
39178 Hayley Fox
39179 Don Frances
39180 Karen Fritsche
39181 Jason Georges
39182 Paul Glickman
39183 Ruxandra Guidi
39184 Adolfo Guzman-Lopez
39185 Hettie Lynne Hurtes
39186 Shirley Jahad
39187 Siel Ju
39188 Steve Julian
39189 Jason Kandel
39190 Queena Kim
39191 Mark Lacter
39192 Michelle Lanz
39193 Jeffrey Long
39194 Larry Mantle
39195 Jacob Margolis
39196 José Martinez
39197 Meghan McCarty
39198 Sharon McNary
39199 Shereen Marisol Meraji
39200 Kathleen Miles
39201 Corey Moore
39202 Julio Morales
39203 Kari Moran
39204 Patt Morrison
39205 Kristen Muller
39206 Patricia Nazario
39207 Arwen Nicks
39208 Kim Nowacki
39209 Stephanie O'Neill
39210 Jackie Oclaray
39211 Lauren Osen
39212 Linda Othenin-Girard
39213 James Panetta
39214 Rita  Pardue
39215 Molly Peterson
39216 Brooke Peterson
39217 Tony Pierce
39218 Steve Proffitt
39219 John Rabe
39220 Bianca Ramirez
39221 Mike Roe
39222 Nick Roman
39223 Vanessa Romo
39224 Mae Ryan
39225 Samantha Schaefer
39226 Alex Schaffert-Callaghan 
39227 Jonathan Serviss
39228 Melanie Sill
39229 Grant  Slater
39230 Julie Small
39231 Russ Stanton
39232 Frank Stoltze
39233 Rob Strauss
39234 Sanden Totten
39235 Susan Valot
39236 Janice Watje-Hurst
39237 Brian Watt
39238 Julie Westfall
39239 Eric Zassenhaus"

lines = output.split("\n")
puts "Records: #{lines.size}"

lines.each do |line|
  arr = line.split(" ", 2)
  asset_id = arr[0]
  name = arr[1]
  if bio = Bio.where(name: arr[1])
    puts "Found bio: #{bio.name}"
    if bio.asset_id.blank?
      if bio.update_attributes(asset_id: name)
        puts "Saved asset_id: #{asset_id} for #{bio.name}"
      else
        puts "Could not save record: #{bio.name}"
      end
    else
      puts "#{bio.name} already has an asset_id."
  else
    puts "Missed bio for #{name}"
  end
end
  
puts "Done!"