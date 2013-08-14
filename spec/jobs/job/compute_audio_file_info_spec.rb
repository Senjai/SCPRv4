require "spec_helper"

describe Job::ComputeAudioFileInfo do
  describe "::perform" do
    it "finds the audio and finds the duration and size, and saves" do
      audio = create :test_class_fake_audio

      # Reset these columns since theoretically 
      # they would have been set already by the callback.
      audio.update_column(:size, nil)
      audio.update_column(:duration, nil)

      Job::ComputeAudioFileInfo.perform(audio.id)
      audio.reload

      audio.size.should be > 0
      audio.duration.should eq 2
    end
  end
end
