require 'spec_helper'

describe Concern::Callbacks::GenerateShortHeadlineCallback do
  it "generates short headline = headline if none is present" do
    story = build :test_class_story, headline: "Newsflash", short_headline: nil
    story.save!
    story.short_headline.should eq "Newsflash"
  end

  it "doesn't generate if should_validate is false" do
    story = build :test_class_story, headline: "Newsflash", short_headline: nil
    story.stub(:should_validate?) { false }
    story.save!
    story.short_headline.should eq nil
  end
end
