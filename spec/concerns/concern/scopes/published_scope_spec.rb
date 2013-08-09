require "spec_helper"

describe Concern::Scopes::PublishedScope do
  it "orders by published_at desc" do
    # There is a bug in the tests somewhere that is leaving a bunch of
    # these objects in the database, but I can't find it, so...
    TestClass::Story.destroy_all

    t = Time.now

    story1 = create :test_class_story, published_at: t - 3.days
    story2 = create :test_class_story, published_at: t - 2.days
    story3 = create :test_class_story, published_at: t - 1.day

    TestClass::Story.published.should eq [story3, story2, story1]
    TestClass::Story.published.to_sql.should match /order by published_at desc/i
  end

  it "only grabs published content" do
    # There is a bug in the tests somewhere that is leaving a bunch of
    # these objects in the database, but I can't find it, so...
    TestClass::Story.destroy_all

    story_published   = create :test_class_story, status: ContentBase::STATUS_LIVE
    story_unpublished = create :test_class_story, status: ContentBase::STATUS_DRAFT
    TestClass::Story.published.should eq [story_published]
  end
end
