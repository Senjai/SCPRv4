require "spec_helper"

describe Audio::UploadedAudio do
  describe "::filename" do
    after :each do
      purge_uploaded_audio
    end

    it "is the mp3's actual filename" do
      audio = build :uploaded_audio
      audio.filename.should eq "point1sec.mp3"
    end
  end

  describe "#store_dir" do
    after :each do
      purge_uploaded_audio
    end

    it "uses Time.now for new records" do
      audio = build :uploaded_audio
      audio.store_dir.should eq "upload/#{Time.now.strftime('%Y/%m/%d')}"
    end

    it "uses the created_at timestamp if this is persisted" do
      audio = build :uploaded_audio
      audio.created_at = 1.week.from_now
      audio.store_dir.should eq "upload/#{1.week.from_now.strftime('%Y/%m/%d')}"
    end
  end
end
