require 'spec_helper'

describe Concern::Callbacks::GenerateTeaserCallback do
  describe '#generate_teaser' do
    it "runs before validation if teaser is blank" do
      story = build :test_class_story, body: "Hello", teaser: nil
      story.save!
      story.teaser.should eq "Hello"
    end

    it "doesn't run if teaser is present" do
      story = build :test_class_story, body: "Okay", teaser: "Okedoke"
      story.save!
      story.teaser.should eq "Okedoke"
    end
  end
end
