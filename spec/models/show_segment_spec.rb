require "spec_helper"

describe ShowSegment do
  describe "callbacks" do
    it_behaves_like "set published at callback"
  end
  
  # ----------------
  
  describe "validations" do
    it_behaves_like "slug validation"
    it_behaves_like "content validation"
    it_behaves_like "slug unique for date validation"
  end

  #------------------
  
  describe "associations" do
    it_behaves_like "content alarm association"
    it_behaves_like "asset association"
    it_behaves_like "audio association"
    
    it { should belong_to :show }
    it { should have_many :rundowns }
    it { should have_many(:episodes).through(:rundowns) }
  end

  #------------------
  
  describe "scopes" do
    it_behaves_like "since scope"
    
    describe "#published" do
      it "orders published content by published_at descending" do
        ShowSegment.published.to_sql.should match /order by published_at desc/i
      end
    end
  end
  
  #------------------
  
  it_behaves_like "status methods"
  it_behaves_like "publishing methods"
  
  describe "#episode" do
    it "uses the first episode the segment is associated with" do
      segment = create :show_segment
      episodes = create_list :show_episode, 3
      episodes.each { |episode| create :show_rundown, episode: episode, segment: segment }
      segment.episode.should eq segment.episodes.first
    end
  end
  
  #------------------
  
  describe "#sister_segments" do
    before :each do
      stub_publishing_callbacks(ShowSegment)
    end
    
    it "uses the other segments from the episode if episodes exist" do
      episode = create :show_episode, segment_count: 3
      episode.segments.last.sister_segments.should eq episode.segments.first(2)
    end
    
    it "uses the 5 latest segments from its program if no episodes exist" do
      program = create :kpcc_program, segment_count: 7
      program.segments.published.last.sister_segments.should eq program.segments.published.first(5)
      program.segments.published.first.sister_segments.should eq program.segments.published[1..5]
    end
    
    it "does not include itself" do
      program = create :kpcc_program, segment_count: 3
      program.segments.first.sister_segments.should_not include program.segments.first
    end
  end

  #------------------

  describe "#byline_elements" do
    it "is an array with the show's title" do
      segment = build :show_segment
      segment.byline_elements.should eq [segment.show.title]
    end
  end     

  #------------------
    
  describe "#canFeature?" do
    it "returns true if there are assets" do
      segment = create :show_segment, asset_count: 1
      segment.canFeature?.should be_true
    end     
    
    it "returns false if there are no assets" do
      segment = create :show_segment, asset_count: 0
      segment.canFeature?.should be_false
    end
  end

  #------------------

  describe "#public_datetime" do
    it "is the published_at date" do
      segment = create :show_segment
      segment.public_datetime.should eq segment.published_at
    end
  end
end
