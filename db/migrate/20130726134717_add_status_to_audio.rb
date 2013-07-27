class AddStatusToAudio < ActiveRecord::Migration
  def change
    add_column :media_audio, :status, :integer
    add_index :media_audio, :status
  end
end
