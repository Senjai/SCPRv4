require "spec_helper"

# These specs also passively test the +status_text+ method.

describe Concern::Methods::StatusMethods do
  subject { TestClass::Story.new }
  
  describe "#killed?" do
    it "is true if status is ContentBase::STATUS_KILLED" do
      subject.status = ContentBase::STATUS_KILLED
      subject.status_text.should_not be_nil
      subject.killed?.should eq true
    end
    
    it "is false if status is not ContentBase::STATUS_KILLED" do
      subject.status = ContentBase::STATUS_DRAFT
      subject.killed?.should eq false
    end
  end
  
  #------------------------
  
  describe "#draft?" do
    it "is true if status is ContentBase::STATUS_DRAFT" do
      subject.status = ContentBase::STATUS_DRAFT
      subject.status_text.should_not be_nil
      subject.draft?.should eq true
    end
    
    it "is false if status is not ContentBase::STATUS_DRAFT" do
      subject.status = ContentBase::STATUS_REWORK
      subject.draft?.should eq false
    end
  end
  
  #------------------------
  
  describe "#awaiting_rework?" do
    it "is true if status is ContentBase::STATUS_REWORK" do
      subject.status = ContentBase::STATUS_REWORK
      subject.status_text.should_not be_nil
      subject.awaiting_rework?.should eq true
    end
    
    it "is false if status is not ContentBase::STATUS_REWORK" do
      subject.status = ContentBase::STATUS_EDIT
      subject.awaiting_rework?.should eq false
    end
  end
  
  #------------------------
  
  describe "#awaiting_edits?" do
    it "is true if status is ContentBase::STATUS_EDIT" do
      subject.status = ContentBase::STATUS_EDIT
      subject.status_text.should_not be_nil
      subject.awaiting_edits?.should eq true
    end
    
    it "is false if status is not ContentBase::STATUS_EDIT" do
      subject.status = ContentBase::STATUS_PENDING
      subject.awaiting_edits?.should eq false
    end
  end
  
  #------------------------
  
  describe "#pending?" do
    it "is true if status is ContentBase::STATUS_PENDING" do
      subject.status = ContentBase::STATUS_PENDING
      subject.status_text.should_not be_nil
      subject.pending?.should eq true
    end
    
    it "is false if status is not ContentBase::STATUS_PENDING" do
      subject.status = ContentBase::STATUS_LIVE
      subject.pending?.should eq false
    end
  end
  
  #------------------------
  
  describe "#published?" do
    it "is true if status is ContentBase::STATUS_LIVE" do
      subject.status = ContentBase::STATUS_LIVE
      subject.status_text.should_not be_nil
      subject.published?.should eq true
    end
    
    it "is false if status is not ContentBase::STATUS_LIVE" do
      subject.status = ContentBase::STATUS_KILLED
      subject.published?.should eq false
    end
  end
end
