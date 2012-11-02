require "spec_helper"

describe Podcast do
  describe "validations" do
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:podcast_url) }
    
    it "validates slug uniqueness" do
      create :podcast
      should validate_uniqueness_of(:slug)
    end
  end
  
  #---------------
  
  describe "associations" do
    it { should belong_to(:source) }
    it { should belong_to(:category) }
  end
  
  #---------------
  
  describe "scopes" do
    describe "::listed" do
      it "only selects listed" do
        listed = create :podcast, is_listed: true
        unlisted = create :podcast, is_listed: false
        Podcast.listed.should eq [listed]
      end
    end
  end
  
  #---------------
  # TODO: This entire spec needs to be rewritten, 
  # the stubbing is fickle with such specific arguments
  describe "#content" do
    let(:sphinx_hash) do
      { 
        :with        => { has_audio: true }, 
        :classes     => [],
        :order       => :published_at, 
        :page        => 1, 
        :per_page    => 25, 
        :sort_mode   => :desc,
        :retry_stale => true
      }
    end
        
    context "for KpccProgram/OtherProgram" do
      it "grabs episodes when item_type is episodes" do
        episode = create :show_episode
        audio   = create :audio, :uploaded
        episode.audio.push audio
        episode.save!
        
        podcast = create :podcast, source: episode.show, item_type: "episodes"
        
        ThinkingSphinx.should_receive(:search).with('', sphinx_hash.merge!(classes: [ShowEpisode], with: { has_audio: true, program: episode.show.id })).and_return([episode])        
        podcast.content.should eq [episode]
      end
      
      it "grabs segments when item_type is segments" do
        segment = create :show_segment
        audio   = create :audio, :uploaded
        segment.audio.push audio
        segment.save!
        
        podcast = create :podcast, source: segment.show, item_type: "segments"
        
        ThinkingSphinx.should_receive(:search).with('', sphinx_hash.merge!(classes: [ShowSegment], with: { has_audio: true, program: segment.show.id })).and_return([segment])        
        podcast.content.should eq [segment]
      end
    end
    
    context "for Blog" do
      it "grabs entries" do
        entry = create :blog_entry
        audio = create :audio, :uploaded
        entry.audio.push audio
        entry.save!
        
        podcast = create :podcast, source: entry.blog
        
        ThinkingSphinx.should_receive(:search).with('', sphinx_hash.merge!(classes: [BlogEntry], with: { has_audio: true, blog: entry.blog.id })).and_return([entry])        
        podcast.content.should eq [entry]
      end
    end
    
    context "for Content" do
      it "grabs content" do        
        story   = create :news_story
        entry   = create :blog_entry
        segment = create :show_segment
        episode = create :show_episode
        
        audio = create :audio, :uploaded
        
        [story, entry, segment, episode].each do |c|
          c.audio.push audio
          c.save!
        end
                
        podcast = create :podcast, item_type: "content", source: nil
        
        ThinkingSphinx.should_receive(:search).with('', sphinx_hash.merge!(classes: ContentBase.content_classes)).and_return([story, entry, segment, episode])        
        podcast.content.sort_by { |c| c.class.name }.should eq [story, entry, segment, episode].sort_by { |c| c.class.name }
      end
    end   
  end
end
