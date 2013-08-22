require "spec_helper"

describe ShowSegment do
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
      segments = create_list :show_segment, 3
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

  describe '#to_article' do
    it 'makes a new article' do
      segment = build :show_segment
      segment.to_article.should be_a Article
    end
  end

  describe '#to_abstract' do
    it 'makes a new abstract' do
      segment = build :show_segment
      segment.to_abstract.should be_a Abstract
    end
  end

  describe '#to_episode' do
    it 'is a lame workaround' do
      segment = build :show_segment
      segment.to_episode.should be_a Episode
      segment.to_episode.segments.should eq Array(segment) # lol
    end
  end
end
