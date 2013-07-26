require "spec_helper"

describe Audio::EncoAudio do
  describe 'enco information validation' do
    context "#enco_info_is_present_together" do
      it "runs on save" do
        audio = build :audio, :enco
        audio.should_receive(:enco_info_is_present_together).once
        audio.save!
      end

      it "fails if enco_number present but not enco_date" do
        audio = build :audio, enco_date: nil, enco_number: 999
        audio.enco_info_is_present_together
        audio.errors.keys.should eq [:base, :enco_number, :enco_date]
      end

      it "fails if enco_date present but not enco_number" do
        audio = build :audio, enco_date: Date.today, enco_number: nil
        audio.enco_info_is_present_together
        audio.errors.keys.should eq [:base, :enco_number, :enco_date]
      end

      it "passes if enco_date and enco_number are present" do
        audio = build :audio, enco_date: Date.today, enco_number: 999
        audio.enco_info_is_present_together
        audio.errors.should be_blank
      end

      it "passes if neither enco_date nor enco_number were provided" do
        audio = build :audio, :direct, enco_date: nil, enco_number: nil
        audio.enco_info_is_present_together
        audio.errors.should be_blank
      end
    end
  end


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

  describe "::bulk_sync" do
    it "sends to Audio::Sync::bulk_sync_awaiting_audio" do
      Audio::Sync.should_receive(:bulk_sync_awaiting_audio).with(Audio::EncoAudio)
      Audio::EncoAudio.bulk_sync
    end
  end
  
  #----------------
  
  describe "#sync" do
    it "sends to Audio::Sync::sync_if_file_exists" do
      enco = create :enco_audio
      Audio::Sync.should_receive(:sync_if_file_exists).with(enco)
      enco.sync
    end
  end
end
