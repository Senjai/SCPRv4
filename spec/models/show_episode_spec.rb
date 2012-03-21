require "spec_helper"

describe ShowEpisode do
  describe "associations" do # TODO move this into content_base_spec
    it { should have_many :assets }
    it { should have_many :bylines }
    it { should have_many :brels }
    it { should have_many :frels }
    it { should have_many :related_links }
    it { should have_many :queries }
    it { should have_one :content_category }
    it { should have_one(:category).through(:content_category) }
    it { should have_one :rundown }
    it { should have_many(:segments).through(:rundown) }
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
