require "spec_helper"

describe Audio::Sync do
  describe "::enqueue_all" do
    it "enqueues SyncAudioJob for each class that should be automagically synced" do
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio::EncoAudio").once
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio::ProgramAudio").once
      Resque.should_receive(:enqueue).with(Audio::SyncAudioJob, "Audio::DirectAudio").once
      Audio::Sync.enqueue_all
    end
  end

  #----------------

  describe "::bulk_sync_awaiting_audio!" do
    it "sends #sync! to all awaiting audio" do
      enco   = create :enco_audio
      direct = create :direct_audio
      Audio::EncoAudio.any_instance.should_receive(:sync!)
      Audio::DirectAudio.any_instance.should_receive(:sync!)
      Audio::Sync.bulk_sync_awaiting_audio!(Audio)
    end
    
    it "only syncs audio from the past 2 weeks by default" do
      enco   = create :enco_audio
      direct = create :direct_audio
      direct.send :write_attribute, :created_at, 4.weeks.ago
      direct.save!
      Audio::EncoAudio.any_instance.should_receive(:sync!)
      Audio::DirectAudio.any_instance.should_not_receive(:sync!)
      Audio::Sync.bulk_sync_awaiting_audio!(Audio)
    end
    
    it "accepts an alternate limit" do
      enco   = create :enco_audio
      direct = create :direct_audio
      direct.send :write_attribute, :created_at, 4.weeks.ago
      direct.save!
      Audio::EncoAudio.any_instance.should_receive(:sync!)
      Audio::DirectAudio.any_instance.should_receive(:sync!)
      Audio::Sync.bulk_sync_awaiting_audio!(Audio, 5.weeks.ago)
    end
  end
  
  #----------------
  
  describe "::sync_if_file_exists!" do
    it "sets the audio's mp3 to the file if the file exists" do
      enco   = create :enco_audio, enco_number: "1234", enco_date: freeze_time_at("October 02, 2012")
      direct = create :direct_audio
      Audio::Sync.sync_if_file_exists!(direct)
      Audio::Sync.sync_if_file_exists!(enco)
      enco.reload.mp3.file.filename.should eq "20121002_features1234.mp3"
      direct.reload.mp3.file.filename.should eq "SomeCoolEvent.mp3"
    end
    
    it "doesn't doesn't do anything if the file doesn't exist" do
      enco   = create :enco_audio, enco_number: "9999", enco_date: freeze_time_at("October 02, 2012")
      direct = create :direct_audio, mp3_path: "events/2012/10/02/NonExistent.mp3"
      Audio::Sync.sync_if_file_exists!(direct)
      Audio::Sync.sync_if_file_exists!(enco)
      enco.reload.mp3.file.should be_blank
      direct.reload.mp3.file.should be_blank
    end
  end
end
