require "spec_helper"

describe Concern::Scopes::SinceScope do
  it "gets only the records from the specified limit" do
    recent     = TestClass::Story.create(headline: "Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "headline", published_at: 1.day.ago)
    really_old = TestClass::Story.create(headline: "Other Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "otherheadline", published_at: 1.year.ago)

    TestClass::Story.since(1.hour.ago).should eq []
    TestClass::Story.since(3.days.ago).should eq [recent]
    TestClass::Story.since(2.years.ago).sort.should eq [recent, really_old].sort
  end
end
