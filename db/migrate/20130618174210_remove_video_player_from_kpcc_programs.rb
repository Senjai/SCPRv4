class RemoveVideoPlayerFromKpccPrograms < ActiveRecord::Migration
  def up
    remove_column :programs_kpccprogram, :video_player
  end

  def down
    add_column :programs_kpccprogram, :video_player, :string
  end
end
