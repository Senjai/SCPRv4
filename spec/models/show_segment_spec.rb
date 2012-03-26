require "spec_helper"

describe ShowSegment do
  describe "associations" do
    it { should belong_to :show }
    it { should have_many :rundowns }
    it { should have_many(:episodes).through(:rundowns) }
    it { should belong_to :enco_audio }
    it { should have_many :uploaded_audio }
  end
  
  describe "link_path" do
    it "does not override the hard-coded options" do
      segment = create :show_segment
      segment.link_path(slug: "wrong").should_not match "wrong"
    end
  end
  
  describe "headline" do
    it "is the title" do
      segment = build :show_segment
      segment.headline.should eq segment.title
    end
  end

  describe "byline_elements" do
    it "is an array with the show's title" do
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
  
  describe "#published" do
    it "orders published content by published_at descending" do
      segments = create_list :show_segment, 3, status: 5
      ShowSegment.published.first.should eq segments.last
      ShowSegment.published.last.should eq segments.first
    end
  end
end