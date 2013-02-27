class RemoveNovemberDataPoints < ActiveRecord::Migration
  def up
    DataPoint.destroy_all
  end

  def down
    $stdout.puts "lol sorry bro"
  end
end
