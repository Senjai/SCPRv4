require 'spec_helper'

describe VideoShell do  
  it "scopes by published" do
    @published = create_list :video_shell, 3, status: 5
    @unpublished = create_list :video_shell, 2, status: 3
    VideoShell.published.count.should eq 3
  end
  
  describe "instance" do # TODO: Move these into ContentBase specs
    it "inherits from ContentBase" do
      @video = create :video_shell
      @video.should be_a ContentBase
    end
    
    describe "#short_headline" do
      it "returns short_headline if defined" do
        short_headline = "Short"
        @video = create :video_shell, _short_headline: short_headline
        @video.short_headline.should eq short_headline
      end
    
      it "returns headline if not defined" do
        @video = create :video_shell
        @video.short_headline.should eq @video.headline
      end
    end
    
    describe "#teaser" do
      it "returns teaser if defined" do
        teaser = "This is a short teaser"
        @video = create :video_shell, _teaser: teaser
        @video.teaser.should eq teaser
      end
    
      it "creates teaser from long paragraph if not defined" do
        @video = create :video_shell
        @video.teaser.should eq "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet..."
      end
      
      it "returns the full first paragraph if it's short enough" do
        short_first_paragraph = "This is just a short paragraph."
        @video = create :video_shell, body: "#{short_first_paragraph}\n And some more!"
        @video.teaser.should eq short_first_paragraph
      end
    end
  end
end