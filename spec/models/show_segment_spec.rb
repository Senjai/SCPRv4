require "spec_helper"

describe ShowSegment do
  describe "headline" do
    it "is the title" do
      segment = build :show_segment
      segment.headline.should eq segment.title
    end
  end

  describe "byline_elements" do
    it "is an array containing the show title" do
      segment = build :show_segment
      segment.byline_elements.should eq [segment.show.title]
    end
  end 	 	
 	 	
  describe "canFeature?" do
    it "returns true if there are assets" do
      segment = create :show_segment, asset_count: 1
      segment.canFeature?.should be_true
    end 	 	
 	 	
    it "returns false if there are no assets" do
      segment = create :show_segment, asset_count: 0
      segment.canFeature?.should be_false
    end
  end
 	 	 	 	
  describe "public_datetime" do
    it "is the published_at date" do
      segment = create :show_segment
      segment.public_datetime.should eq segment.published_at
    end
  end	
end