class UpdatedCreatedAtTimestampsInAudio < ActiveRecord::Migration
  def up
    Audio::UploadedAudio.find_in_batches do |group|
      group.each do |audio|
        date_parts = audio.read_attribute(:store_dir).split("/")[1..-1]

        year    = date_parts[0].to_i
        month   = date_parts[1].to_i
        day     = date_parts[2].to_i

        date = Time.new(year, month, day, 0)

        audio.update_column(:created_at, date)
      end
    end
  end

  def down
  end
end
