require "spec_helper"

describe ShowRundown do
  describe "associations" do
    it { should belong_to(:episode).class_name("ShowEpisode") }
    it { should belong_to(:segment).class_name("Segment") }
  end
  
  describe "check_segment_order" do
    it "only runs if segment_order is blank" do
      rundown = create :show_rundown, segment_order: 20
      rundown.segment_order.should eq 20
    end
    
    it "sets a segment order if none is specified" do
      rundown = build :show_rundown
      rundown.segment_order.should be_blank
      rundown.save
      rundown.segment_order.should_not be_blank
    end
    
    it "sets the segment order to 1 if it is the first segment" do
      rundown = create :show_rundown
      rundown.segment_order.should eq 1
    end
    
    it "increases the last segment_order by 1 if other segments exist" do
      episode = create :show_episode
      rundown = create :show_rundown, episode: episode, segment_order: 5
      rundown2 = create :show_rundown, episode: episode
      rundown2.segment_order.should eq 6
    end
  end
end
