class NullifyEventColumns < ActiveRecord::Migration
  def up
    Event.all.each do |event|
      event.attributes.keys.each do |a|
        if event[a] == ""
          event[a] = nil
          $stdout.puts "Nullified #{a} for #{event.simple_title}"
        end
      end
      
      if event.changed_attributes.present?
        event.save!
      end
    end
  end

  def down
  end
end
