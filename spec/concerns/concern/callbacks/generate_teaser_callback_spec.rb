require 'spec_helper'

describe Concern::Callbacks::GenerateTeaserCallback do
  describe '#generate_teaser' do
    it "runs before validation if teaser is blank" do
      story = build :test_class_story, body: "Hello", teaser: nil
      story.save!
      story.teaser.should eq "Hello"
    end

    it "returns the full first paragraph if it's short enough" do
      first   = "This is just a short paragraph."
      story = build :test_class_story, body: "#{first}\n And some more!"
      story.generate_teaser
      story.teaser.should eq first
    end
    
    it "creates teaser from long paragraph if not defined" do
      long_body = load_fixture("long_text.txt")
      long_body.should match /\n/
      story.generate_teaser
      story.teaser.should match /\ALorem ipsum (.+)\.{3,}\z/
      story.teaser.should_not match /\n/
    end
  end
end
