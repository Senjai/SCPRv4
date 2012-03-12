require "spec_helper"

describe ShowEpisode do
  describe "link_path" do
    it "does not override the hard-coded options" do
      episode = create :show_episode
      episode.link_path(show: "wrong").should_not match "wrong"
    end
  end
end
