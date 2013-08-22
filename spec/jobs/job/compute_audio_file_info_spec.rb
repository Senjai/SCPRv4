require "spec_helper"

describe Job::ComputeAudioFileInfo do
  describe "::perform" do
    it "finds the audio and finds the duration and size, and saves" do
      audio = create :enco_audio, :live_enco, :live

      # Reset these columns since theoretically 
      # they would have been set already by the callback.
      audio.update_column(:size, nil)
      audio.update_column(:duration, nil)

      audio.size.should eq nil
      audio.duration.should eq nil

      Job::ComputeAudioFileInfo.perform(audio.id)
      audio.reload

      audio.size.should be > 0
      audio.duration.should eq 0 # it's actually the point1sec file
    end

    it "doesn't save if the mp3_file is blank" do
      audio = create :enco_audio
      Audio::EncoAudio.any_instance.should_not_receive(:save!)

      Job::ComputeAudioFileInfo.perform(audio.id)
    end
  end
end
