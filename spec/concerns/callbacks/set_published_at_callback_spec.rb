require "spec_helper"

describe Concern::Callbacks::SetPublishedAtCallback do
  subject { TestClass::Story.new(headline: "Headline", body: "Cool Body", status: ContentBase::STATUS_LIVE, slug: "headline") }
  
  describe "#should_set_published_at_to_now?" do
    it "is true if publishing? is true and published_at if blank" do
      subject.stub(:publishing?) { true }
      subject.stub(:published_at) { nil }
      subject.should_set_published_at_to_now?.should be_true
    end
    
    it "is false if publishing? is false and published_at is blank" do
      subject.stub(:publishing?) { false }
      subject.stub(:published_at) { nil }
      subject.should_set_published_at_to_now?.should be_false
    end
    
    it "is false if publishing? is true and published_at is present" do
      subject.stub(:publishing?) { true }
      subject.stub(:published_at) { Time.now }
      subject.should_set_published_at_to_now?.should be_false
    end
    
    it "is false if publishing? is false and published_at is present" do
      subject.stub(:publishing?) { false }
      subject.stub(:published_at) { Time.now }
      subject.should_set_published_at_to_now?.should be_false
    end
  end

  #-----------------
  
  describe "#set_published_at_to_now" do
    context "should_set_published_at_to_now is true" do
      before :each do
        subject.stub(:should_set_published_at_to_now?) { true }
      end
      
      it "sets published at to now" do
        time = freeze_time_at(Time.now)
        subject.save!
        subject.published_at.should eq time
      end
    end
    
    context "should_set_published_at_to_now is false" do
      before :each do
        subject.stub(:should_set_published_at_to_now?) { false }
        subject.status = ContentBase::STATUS_DRAFT
      end
      
      it "does not set published at to now" do
        time = freeze_time_at(Time.now)
        subject.save!
        subject.published_at.should be_nil
      end
    end
  end

  #-----------------
  
  describe "#should_set_published_at_to_alarm?" do
    let(:content_alarm) { build :content_alarm }
    
    it "is true if alarm is present and alarm.fire_at has changed" do
      subject.stub(:alarm) { content_alarm }
      subject.alarm.stub(:fire_at_changed?) { true }
      subject.should_set_published_at_to_alarm?.should be_true
    end

    it "is false if alarm is present and alarm.fire_at has not changed" do
      subject.stub(:alarm) { content_alarm }
      subject.alarm.stub(:fire_at_changed?) { false }
      subject.should_set_published_at_to_alarm?.should be_false
    end

    it "is false if alarm is not present" do
      subject.stub(:alarm) { nil }
      subject.should_set_published_at_to_alarm?.should be_false
    end
  end
  
  #-----------------
  
  describe "#set_published_at_to_alarm" do
    context "should_set_published_at_to_alarm? is true" do
      before :each do
        subject.published_at = Chronic.parse("8pm")
        subject.stub(:should_set_published_at_to_alarm?) { true }
        subject.build_alarm(fire_at: Chronic.parse("4pm"))
        subject.save!
      end
      
      it "sets published_at to the alarm's fire_at date" do
        subject.published_at.should eq Chronic.parse("4pm")
        subject.published_at.should_not eq Chronic.parse("8pm")
      end
    end

    context "should_set_published_at_to_alarm? is false" do
      before :each do
        subject.published_at = Chronic.parse("8pm")
        subject.stub(:should_set_published_at_to_alarm?) { false }
        subject.build_alarm(fire_at: Chronic.parse("4pm"))
        subject.save!
      end
      
      it "does not set published_at to the alarm's fire_at date" do
        subject.published_at.should_not eq Chronic.parse("4pm")
        subject.published_at.should eq Chronic.parse("8pm")
      end
    end
  end
  
  #-----------------
  
  describe "#should_set_published_at_to_nil?" do
    it "is true if #unpublishing? is true" do
      subject.stub(:unpublishing?) { true }
      subject.should_set_published_at_to_nil?.should be_true
    end
    
    it "is false if #unpublishing? is false" do
      subject.stub(:unpublishing?) { false }
      subject.should_set_published_at_to_nil?.should be_false
    end
  end
  
  #-----------------
  
  describe "#set_published_at_to_nil" do
    context "should_set_published_at_to_nil? is true" do
      before :each do
        subject.published_at = Time.now - 1.hour
        subject.stub(:should_set_published_at_to_nil?) { true }
        subject.published_at.should_not be_nil
        subject.save!
      end
      
      it "sets published_at to nil" do
        subject.published_at.should eq nil
      end
    end

    context "should_set_published_at_to_nil? is false" do
      before :each do
        subject.published_at = Time.now
        subject.stub(:should_set_published_at_to_nil?) { false }
        subject.published_at.should_not be_nil
        subject.save!
      end
      
      it "does not set published_at to nil" do
        subject.published_at.should_not be_nil
      end
    end
  end
end
