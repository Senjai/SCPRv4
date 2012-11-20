require "spec_helper"

describe Concern::Scopes::PublishedScope do
  it "orders by published_at desc" do
    story1 = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
    story3 = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug3", published_at: Time.now+2.hour, status: ContentBase::STATUS_LIVE)
    story2 = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug2", published_at: Time.now+1.hour, status: ContentBase::STATUS_LIVE)
    TestClass::Story.published.should eq [story3, story2, story1]
    TestClass::Story.published.to_sql.should match /order by published_at desc/i
  end
  
  it "only grabs published content" do
    story_published   = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
    story_unpublished = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug2", published_at: Time.now, status: ContentBase::STATUS_DRAFT)
    TestClass::Story.published.should eq [story_published]
  end
end
