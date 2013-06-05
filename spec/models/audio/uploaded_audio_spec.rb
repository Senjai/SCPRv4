require "spec_helper"

describe Audio::UploadedAudio do
  describe "::filename" do
    it "is the mp3's actual filename" do
      audio = build :audio, :uploaded
      Audio::ProgramAudio.filename(audio).should eq "point1sec.mp3"
    end
  end
  
  #----------------
  
  describe "::store_dir" do
    it "is the root upload dir with date paths" do
      stub_const("Audio::STORE_DIRS", { upload: "upload"} )
      time  = freeze_time_at("October 21, 1988")
      audio = build :audio, :uploaded
      Audio::UploadedAudio.store_dir(audio).should eq "upload/1988/10/21"
    end
  end
end
