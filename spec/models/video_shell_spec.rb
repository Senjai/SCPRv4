require 'spec_helper'

describe VideoShell do
  describe "#teaser" do
    it "is the body" do
      video = build :video_shell
      video.body.should eq video.teaser
    end
  end
end
