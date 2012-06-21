require "spec_helper"

describe ShowEpisode do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :air_date }
    it { should validate_presence_of :show_id }
  end
  
  describe "associations" do
    it { should have_many :rundowns }
    it { should have_many(:segments).through(:rundowns) }
    it { should belong_to :show }
  end
  
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
