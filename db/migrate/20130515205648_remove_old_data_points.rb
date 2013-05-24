class RemoveOldDataPoints < ActiveRecord::Migration
  def up
    DataPoint.where(group_name: "election-march2013").destroy_all
  end

  def down
    puts "sorry bro"
  end
end
