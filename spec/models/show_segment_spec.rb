require "spec_helper"

describe ShowSegment do
  describe "associations" do # TODO move this into content_base_spec
    it { should have_many :assets }
    it { should have_many :bylines }
    it { should have_many :brels }
    it { should have_many :frels }
    it { should have_many :related_links }
    it { should have_many :queries }
    it { should have_one :content_category }
    it { should have_one(:category).through(:content_category) }
    it { should belong_to :show }
    it { should have_many :rundowns }
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