require 'spec_helper'

describe VideoShell do
  describe "associations" do
    it "responds to category" do
      @video = create_list :video_shell, 3
      @video.any? { |v| v.category == nil }.should be_false
    end
  
    it "has assets" do
      @video = create_list :video_shell, 3
      @video.any? { |v| v.assets == nil }.should be_false
    end
  end
  
  describe "scopes" do
    it "#published only selects published content" do
      @published = create_list :video_shell, 3, status: 5
      @unpublished = create_list :video_shell, 2, status: 3
      VideoShell.published.count.should eq 3
    end
  
    it "#published orders by published_at descending" do
      @video_shells = 3.times { |n| create :video_shell, status: 5, published_at: Time.now + 60*n }
      VideoShell.published.first.should eq VideoShell.where(status: ContentBase::STATUS_LIVE).order("published_at desc").first
    end
  end
  
  describe "instance" do # TODO: Move these into ContentBase specs
    it "inherits from ContentBase" do
      @video = build :video_shell
      @video.should be_a ContentBase
    end
    
    describe "link_path" do
      it "does not override the hard-coded options" do
        video_shell = create :video_shell
        video_shell.link_path(trailing_slash: false).match(/\/$/).should_not be_nil
      end
    end
      
    describe "#short_headline" do
      it "returns short_headline if defined" do
        short_headline = "Short"
        @video = build :video_shell, _short_headline: short_headline
        @video.short_headline.should eq short_headline
      end
    
      it "returns headline if not defined" do
        @video = build :video_shell
        @video.short_headline.should eq @video.headline
      end
    end
    
    describe "#teaser" do
      it "returns teaser if defined" do
        teaser = "This is a short teaser"
        @video = build :video_shell, _teaser: teaser
        @video.teaser.should eq teaser
      end
    
      it "creates teaser from long paragraph if not defined" do
        @video = build :video_shell
        @video.teaser.should eq "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet..."
      end
      
      it "returns the full first paragraph if it's short enough" do
        short_first_paragraph = "This is just a short paragraph."
        @video = build :video_shell, body: "#{short_first_paragraph}\n And some more!"
        @video.teaser.should eq short_first_paragraph
      end
    end
  end
end