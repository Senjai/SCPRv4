require 'spec_helper'

describe NewsStory do
  describe "link_path" do
    it "does not override the hard-coded options" do
      news_story = create :news_story
      news_story.link_path(slug: "wrong").match("wrong").should be_nil
    end
  end
end