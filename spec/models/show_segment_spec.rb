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
      episode = build :show_episode
      segments = create_list :segment, 3
      episode.segments = segments
      episode.save!
      
      episode.segments.last.sister_segments.should eq episode.segments.first(2)
    end
    
    it "uses the 5 latest segments from its program if no episodes exist" do
      program = create :kpcc_program
      create_list :show_segment, 7, show: program
      program.segments.published.last.sister_segments.should eq program.segments.published.first(5)
      program.segments.published.first.sister_segments.should eq program.segments.published[1..5]
    end
    
    it "does not include itself" do
      program = create :kpcc_program
      create_list :show_segment, 3, show: program
      program.segments.first.sister_segments.should_not include program.segments.first
    end
  end

  #------------------

  describe "#byline_extras" do
    it "is an array with the show's title" do
      segment = build :show_segment
      segment.byline_extras.should eq [segment.show.title]
    end
  end
end
