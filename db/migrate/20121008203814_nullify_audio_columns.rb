class NullifyAudioColumns < ActiveRecord::Migration
  def up
    Audio.all.each do |audio|
      audio.attributes.keys.each do |a|
        if audio[a] == ""
          audio[a] = nil
          $stdout.puts "Nullified #{a} for Audio ##{audio.id}"
        end
      end
      
      # Also catch the enco's with only date here
      if audio.enco_date.present? && audio.enco_number.blank?
        audio.enco_date = nil
      end
      
      if audio.changed_attributes.present?
        audio.save!
      end
    end
  end

  def down
  end
end
