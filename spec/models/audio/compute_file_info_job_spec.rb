require "spec_helper"

describe Audio::ComputeFileInfoJob do
  describe "::perform" do
    it "finds the audio and sends to Audio#compute_file_info!" do
      audio = create :audio, :uploaded
      Audio.should_receive(:find).with(audio.id).and_return(audio)
      audio.should_receive(:compute_file_info!)
      Audio::ComputeFileInfoJob.perform(audio.id)

      purge_uploaded_audio
    end
  end
end
