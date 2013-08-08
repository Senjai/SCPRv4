class AddPathToAudio < ActiveRecord::Migration
  def change
    add_column :media_audio, :path, :string
  end
end
