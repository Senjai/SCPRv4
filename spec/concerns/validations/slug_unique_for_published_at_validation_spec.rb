require "spec_helper"

describe Concern::Validations::SlugUniqueForPublishedAtValidation do  
  context "should validate" do
    before :each do
      TestClass::Story.any_instance.stub(:should_validate?) { true }
    end
    
    it "validates slug uniqueness for date" do
      object1 = TestClass::Story.create headline: "Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "something", published_at: Time.new(2012, 11, 14, 1)
      object2 = TestClass::Story.new headline: "Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "something", published_at: Time.new(2012, 11, 16)
      object3 = TestClass::Story.new headline: "Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "something", published_at: Time.new(2012, 11, 14, 5)

      object2.should be_valid
      object3.should_not be_valid
      object3.errors.keys.should include :slug
    end
  end
  
  context "should not validate" do
    before :each do
      TestClass::Story.any_instance.stub(:should_validate?) { false }
    end
    
    it "does not validate slug uniqueness for date" do
      object1 = TestClass::Story.create headline: "Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "something", published_at: Time.new(2012, 11, 14, 1)
      object2 = TestClass::Story.new headline: "Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "something", published_at: Time.new(2012, 11, 16)
      object3 = TestClass::Story.new headline: "Headline", body: "Body", status: ContentBase::STATUS_LIVE, slug: "something", published_at: Time.new(2012, 11, 14, 5)

      object2.should be_valid
      object3.should be_valid
      object3.errors.keys.should be_empty
    end
  end
end
