require "spec_helper"

describe ShowEpisode do
  describe "callbacks" do
    it_behaves_like "set published at callback"
  end
  
  # ----------------
  
  describe "associations" do
    it_behaves_like "content alarm association"
    it_behaves_like "asset association"
    it_behaves_like "audio association"
    
    it { should have_many(:rundowns) }
    it { should have_many(:segments).through(:rundowns) }
    it { should belong_to(:show) }
  end
  
  #------------------
  
  describe "validations" do
    it_behaves_like "content validation"

    it { should validate_presence_of(:show) }
    
    it "validates air date on publish" do
      ShowEpisode.any_instance.stub(:published?) { true }
      should validate_presence_of(:air_date)
    end
  end

  #------------------
  
  describe "scopes" do
    it_behaves_like "since scope"
    
    describe "#published" do
      it "orders published content by air_date descending" do
        episodes = create_list :show_episode, 3, status: 5
        ShowEpisode.published.first.should eq episodes.last
        ShowEpisode.published.last.should eq episodes.first
      end
    end
  end
  
  #------------------
  
  it_behaves_like "status methods"
  it_behaves_like "publishing methods"
  
  describe "content base methods" do
    it { should_not respond_to :disqus_identifier }
  end
  
  # ----------------

  describe "#has_format?" do
    it "is true" do
      create(:show_episode).has_format?.should be_false
    end
  end
  
  #------------------
  
  describe "#body" do
    it "is the teaser" do
      show_episode = build :show_episode
      show_episode.body.should eq show_episode.teaser
    end
  end  
end
