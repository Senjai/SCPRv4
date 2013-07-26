class AddStatusToAudio < ActiveRecord::Migration
  def change
    add_column :media_audio, :status, :integer
  end
end
