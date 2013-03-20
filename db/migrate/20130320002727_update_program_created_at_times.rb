class UpdateProgramCreatedAtTimes < ActiveRecord::Migration
  def up
    KpccProgram.all.each do |program|
      if first_episode = program.episodes.published.reorder("air_date").first
        program.update_attribute(:created_at, first_episode.air_date)
      elsif first_segment = program.segments.published.reorder("published_at").first
        program.update_attribute(:created_at, first_segment.published_at)
      else
        $stdout.puts "no episodes or segments for #{program.to_title}"
      end
    end
  end

  def down
  end
end
