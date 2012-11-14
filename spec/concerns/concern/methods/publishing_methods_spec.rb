require "spec_helper"

describe Concern::Methods::PublishingMethods do
  subject { TestClass::Story.new }
  
  describe "#publishing?" do
    it "is true if status was changed and object is published" do
      subject.stub(:status_changed?) { true }
      subject.stub(:published?) { true }
      subject.publishing?.should eq true
    end
    
    it "is false if status was not changed" do
      subject.stub(:status_changed?) { false }
      subject.stub(:published?) { true }
      subject.publishing?.should eq false
    end
    
    it "is false if status was changed to something non-published" do
      subject.stub(:status_changed?) { true }
      subject.stub(:published?) { false }
      subject.publishing?.should eq false
    end
  end
  
  #--------------------
  
  describe "#unpublishing?" do
    it "is true if status was changed FROM published TO not published" do
      subject.stub(:status_changed?) { true }
      subject.stub(:status_was) { ContentBase::STATUS_LIVE }
      subject.unpublishing?.should eq true
    end
    
    it "is false if status was not changed it" do
      subject.stub(:status_changed?) { false }
      subject.stub(:status_was) { ContentBase::STATUS_EDIT }
      subject.unpublishing?.should eq false
    end
    
    it "is false if status was changed from not published" do
      subject.stub(:status_changed?) { true }
      subject.stub(:status_was) { ContentBase::STATUS_EDIT }
      subject.unpublishing?.should eq false
    end
  end
end
