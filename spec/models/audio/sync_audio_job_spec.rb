require "spec_helper"

describe Audio::SyncAudioJob do
  describe "::perform" do
    it "sends to klass.sync!" do
      Audio.should_receive(:sync!)
      Audio::SyncAudioJob.perform(Audio)
    end
  end
end
