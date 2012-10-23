class PopulateBioLastNames < ActiveRecord::Migration
  def up
    Bio.all.each do |bio|
      bio.save!
      puts "Bio ##{bio.id}: Last name is #{bio.last_name}"
    end
    
    add_index "bios_bio", "last_name"
    add_index "bios_bio", ["is_public", "last_name"]
  end

  def down
    Bio.update_all(last_name: nil)
    remove_index "bios_bio", "last_name"
    remove_index "bios_bio", ["is_public", "last_name"]
  end
end
