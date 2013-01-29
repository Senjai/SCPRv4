require "spec_helper"

describe Concern::Scopes::PublishedScope do
  it "orders by published_at desc" do
    story1 = create :test_class_story, published_at: 3.day.ago
    story2 = create :test_class_story, published_at: 2.days.ago
    story3 = create :test_class_story, published_at: 1.days.ago
    TestClass::Story.published.should eq [story3, story2, story1]
    TestClass::Story.published.to_sql.should match /order by published_at desc/i
  end
  
  it "only grabs published content" do
    story_published   = create :test_class_story, status: ContentBase::STATUS_LIVE
    story_unpublished = create :test_class_story, status: ContentBase::STATUS_DRAFT
    TestClass::Story.published.should eq [story_published]
  end
end
