require "spec_helper"

describe VideoController do
  it "has the video's slug in the path" do
    video = create :video_shell
    video_path(video).should eq "/video/#{video.id}/#{video.slug}"
  end
end