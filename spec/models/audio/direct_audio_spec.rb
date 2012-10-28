require "spec_helper"

describe Audio::DirectAudio do
  describe "::filename" do
    it "is the supplied mp3's filename" do
      audio = build :audio, :direct, mp3_path: "/some/cool/audio_bro.mp3"
      Audio::DirectAudio.filename(audio).should eq "audio_bro.mp3"
    end
  end
  
  #----------------
  
  describe "::store_dir" do
    it "is the supplied mp3's base path" do
      audio = build :audio, :direct, mp3_path: "/some/cool/audio_bro.mp3"
      Audio::DirectAudio.store_dir(audio).should eq "/some/cool"
    end
  end
  
  #----------------

  describe "::bulk_sync!" do
    it "sends to Audio::Sync::bulk_sync_awaiting_audio!" do
      Audio::Sync.should_receive(:bulk_sync_awaiting_audio!).with(Audio::DirectAudio)
      Audio::DirectAudio.bulk_sync!
    end
  end
  
  #----------------
  
  describe "::sync!" do
    it "sends to Audio::Sync::sync_if_file_exists!" do
      direct = create :direct_audio
      Audio::Sync.should_receive(:sync_if_file_exists!).with(direct)
      direct.sync!
    end
  end
end
