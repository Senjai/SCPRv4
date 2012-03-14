require "spec_helper"

describe ShowEpisode do
  describe "link_path" do
    it "does not override the hard-coded options" do
      episode = create :show_episode
      episode.link_path(show: "wrong").should_not match "wrong"
    end
  end
  
  describe "#published" do
    it "orders published content by air_date descending" do
      episodes = create_list :show_episode, 3, status: 5
      ShowEpisode.published.first.should eq episodes.last
      ShowEpisode.published.last.should eq episodes.first
    end
  end
end
