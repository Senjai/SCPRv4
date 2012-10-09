class NullifyAudioColumns < ActiveRecord::Migration
  def up
    Audio.all.each do |audio|
      audio.attributes.keys.each do |a|
        if audio[a] == ""
          audio[a] = nil
          $stdout.puts "Nullified #{a} for Audio ##{audio.id}"
        end
      end
      
      # If a piece of enco information is missing, nullify them
      if audio.enco_date.blank? || audio.enco_number.blank?
        audio.enco_date   = nil
        audio.enco_number = nil
      end
      
      if audio.changed_attributes.present?
        audio.save!
      end
    end
  end

  def down
  end
end
