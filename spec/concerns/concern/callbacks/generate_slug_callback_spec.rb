require "spec_helper"

describe Concern::Callbacks::GenerateSlugCallback do
  it "generates slug if it's blank by default" do
    story = build :test_class_story, headline: "This is a ... WEIRD headline! And it's kind of long too, what's up with that?", slug: nil
    story.save!
    story.slug.should match /\Athis-is-a-weird/
    story.slug.length.should eq 50
  end
  
  it "chomps trailing hyphens" do
    story = build :test_class_story, headline: "012345678901234567890123456789012345678901234567---", slug: nil
    story.generate_slug
    story.slug.should_not match /-\z/
    story.slug.should match /7\z/
  end
  
  it "doesn't generate slug if it already existed" do
    story = build :test_class_story, slug: "test-test", headline: "Sweet headline bro"
    story.save!
    story.slug.should eq "test-test"
  end
  
  it "doesn't generate the slug if should_validate? is false" do
    story = build :test_class_story, slug: nil, headline: "Sweet Headline"
    story.stub(:should_validate?) { false }
    story.save!
    story.slug.should eq nil
  end
  
  it "doesn't generate slug if headline is blank" do
    story = build :test_class_story, headline: "", slug: nil
    story.generate_slug
    story.slug.should eq nil
  end
end
