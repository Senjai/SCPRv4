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
  
  describe "::sync!" do
    it "sends to Audio::Sync#sync_awaiting_audio_if_file_exists!" do
      Audio::Sync.any_instance.should_receive(:sync_awaiting_audio_if_file_exists!)
      Audio::DirectAudio.sync!
    end
  end
end
