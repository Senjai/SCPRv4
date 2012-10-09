require "spec_helper"

describe Audio::EncoAudio do
  describe "::filename" do
    it "is makes the filename based on enco number and date" do
      audio = build :enco_audio, enco_number: "1234", enco_date: freeze_time_at("October 21, 1988")
      Audio::EncoAudio.filename(audio).should eq "19881021_features1234.mp3"
    end
  end
  
  #----------------
  
  describe "::store_dir" do
    it "is the predetermined enco folder" do
      stub_const("Audio::STORE_DIRS", { enco: "features" })
      audio = build :enco_audio
      Audio::EncoAudio.store_dir(audio).should eq "features"
    end
  end
  
  #----------------
  
  describe "::sync!" do
    it "sends to Audio::Sync.sync_awaiting_audio_if_file_exists!" do
      Audio::Sync.should_receive(:sync_awaiting_audio_if_file_exists!)
      Audio::EncoAudio.sync!
    end
  end
end
