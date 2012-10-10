require "spec_helper"

describe Audio::Sync do
  describe "::sync_each!" do
    it "enqueues SyncAudioJob for each class that should be automagically synced" do
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio::EncoAudio").once
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio::ProgramAudio").once
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio::DirectAudio").once
      Audio::Sync.new.sync_each!
    end
  end

  #----------------
  
  describe "::sync_awaiting_audio_if_file_exists!" do
    it "sets the audio's mp3 to the file if the file exists" do
      enco   = create :enco_audio, enco_number: "1234", enco_date: freeze_time_at("October 02, 2012")
      direct = create :direct_audio
      Audio::Sync.new(Audio::DirectAudio).sync_awaiting_audio_if_file_exists!
      Audio::Sync.new(Audio::EncoAudio).sync_awaiting_audio_if_file_exists!
      enco.reload.mp3.file.filename.should eq "20121002_features1234.mp3"
      direct.reload.mp3.file.filename.should eq "SomeCoolEvent.mp3"
    end
    
    it "doesn't doesn't do anything if the file doesn't exist" do
      enco   = create :enco_audio, enco_number: "9999", enco_date: freeze_time_at("October 02, 2012")
      direct = create :direct_audio, mp3_path: "events/2012/10/02/NonExistent.mp3"
      Audio::Sync.new(Audio::DirectAudio).sync_awaiting_audio_if_file_exists!
      Audio::Sync.new(Audio::EncoAudio).sync_awaiting_audio_if_file_exists!
      enco.reload.mp3.file.should be_blank
      direct.reload.mp3.file.should be_blank
    end
  end
end
