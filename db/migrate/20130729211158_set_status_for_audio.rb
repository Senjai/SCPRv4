class SetStatusForAudio < ActiveRecord::Migration
  def up
    Audio::DirectAudio.update_all(status: Audio::STATUS_LIVE)
    Audio::UploadedAudio.update_all(status: Audio::STATUS_LIVE)
    Audio::ProgramAudio.update_all(status: Audio::STATUS_LIVE)

    Audio::EncoAudio.where("mp3 is not null").update_all(status: Audio::STATUS_LIVE)
    Audio::EncoAudio.where("mp3 is null").update_all(status: Audio::STATUS_WAIT)
  end

  def down
    Audio.update_all(status: nil)
  end
end
