require 'spec_helper'

describe NewsStory do
  describe "link_path" do
    it "does not override the hard-coded options" do
      news_story = create :news_story
      news_story.link_path(slug: "wrong").should_not match "wrong"
    end
  end
  
  describe "#published" do
    it "orders published content by published_at descending" do
      stories = create_list :news_story, 3, status: 5
      NewsStory.published.first.should eq stories.last
      NewsStory.published.last.should eq stories.first
    end
  end
end