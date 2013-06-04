require "spec_helper"

describe ShowRundown do
  describe "associations" do
    it { should belong_to(:episode).class_name("ShowEpisode") }
    it { should belong_to(:segment).class_name("ShowSegment") }
  end
  
  describe "check_position" do
    it "only runs if position is blank" do
      rundown = create :show_rundown, position: 20
      rundown.position.should eq 20
    end
    
    it "sets a segment order if none is specified" do
      rundown = build :show_rundown
      rundown.position.should be_blank
      rundown.save
      rundown.position.should_not be_blank
    end
    
    it "sets the segment order to 1 if it is the first segment" do
      rundown = create :show_rundown
      rundown.position.should eq 1
    end
    
    it "increases the last position by 1 if other segments exist" do
      episode = create :show_episode
      rundown = create :show_rundown, episode: episode, position: 5
      rundown2 = create :show_rundown, episode: episode
      rundown2.position.should eq 6
    end
  end
end
