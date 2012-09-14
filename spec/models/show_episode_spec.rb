require "spec_helper"

describe ShowEpisode do
  describe "validations" do
    it_behaves_like "content validation"

    it { should validate_presence_of :show_id }
    
    it "validates air date on publish" do
      ShowEpisode.any_instance.stub(:published?) { true }
      should validate_presence_of :air_date
    end
  end
  
  #------------------
  
  describe "content base methods" do
    it { should_not respond_to :disqus_identifier }
  end
  
  #------------------
  
  describe "associations" do
    it { should have_many :rundowns }
    it { should have_many(:segments).through(:rundowns) }
    it { should belong_to :show }
  end
  
  #------------------
  
  describe "#link_path" do
    it "does not override the hard-coded options" do
      episode = create :show_episode
      episode.link_path(show: "wrong").should_not match "wrong"
    end
  end
  
  # ----------------

  describe "#has_format?" do
    it "is true" do
      create(:show_episode).has_format?.should be_false
    end
  end

  # ----------------
  
  describe "#auto_published_at" do
    it "is true" do
      create(:show_episode).auto_published_at.should be_true
    end
  end
  
  #------------------
  
  describe "#body" do
    it "is the teaser" do
      show_episode = build :show_episode
      show_episode.body.should eq show_episode.teaser
    end
  end
  
  #------------------
  
  describe "#published" do
    it "orders published content by air_date descending" do
      episodes = create_list :show_episode, 3, status: 5
      ShowEpisode.published.first.should eq episodes.last
      ShowEpisode.published.last.should eq episodes.first
    end
  end
end
