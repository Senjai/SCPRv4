require "spec_helper"

describe Concern::Scopes::SinceScope do
  it "gets only the records from the specified limit" do
    recent     = create :test_class_story, published_at: 1.day.ago
    really_old = create :test_class_story, published_at: 1.year.ago

    TestClass::Story.since(1.hour.ago).should eq []
    TestClass::Story.since(3.days.ago).should eq [recent]
    TestClass::Story.since(2.years.ago).sort.should eq [recent, really_old].sort
  end
end
