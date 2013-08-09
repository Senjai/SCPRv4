class ChangeEpisodeAirDateToTime < ActiveRecord::Migration
  def up
    change_column :shows_episode, :air_date, :datetime
  end

  def down
    change_column :shows_episode, :air_date, :date
  end
end
