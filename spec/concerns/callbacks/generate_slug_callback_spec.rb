require "spec_helper"

describe Concern::Callbacks::GenerateSlugCallback do
  it "generates slug if it's blank by default" do
    story = TestClass::Story.new(headline: "This is a ... WEIRD headline! And it's kind of long too, what's up with that?", body: "Cool Body", status: ContentBase::STATUS_LIVE)
    story.save!
    story.slug.should match /this-is-a-weird/
    story.slug.length.should eq 50
  end
  
  it "chomps trailing hyphens" do
    story = TestClass::Story.new(headline: "012345678901234567890123456789012345678901234567---", body: "Cool Body", status: ContentBase::STATUS_LIVE)
    story.save!
    story.slug.should_not match /-$/
    story.slug.should match /7$/
  end
  
  it "doesn't generate slug if it already existed" do
    story = TestClass::Story.new(slug: "test-test", headline: "This is a ... WEIRD headline! And it's kind of long too, what's up with that?", body: "Cool Body", status: ContentBase::STATUS_LIVE)
    story.save!
    story.slug.should eq "test-test"
  end
end
