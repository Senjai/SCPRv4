require "spec_helper"

describe Concern::Scopes::SinceScope do
  it "gets only the records from the specified limit" do
    # There is a bug in the tests somewhere that is leaving a bunch of
    # these objects in the database, but I can't find it, so...
    TestClass::Story.destroy_all

    t = Time.now

    recent     = create :test_class_story, published_at: t - 1.day
    really_old = create :test_class_story, published_at: t - 1.year

    TestClass::Story.since(t - 1.hour).should eq []
    TestClass::Story.since(t - 3.days).should eq [recent]
    TestClass::Story.since(t - 2.years).sort.should eq [recent, really_old].sort
  end
end
