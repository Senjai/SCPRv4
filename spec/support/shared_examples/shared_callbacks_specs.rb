##
# Shared Callbacks
# Model::Callbacks
#

#------------------
# SetPublishedAtCallback
shared_examples_for "set published at callback" do  
  describe "#should_set_published_at_to_now?" do
    let(:object) { build symbolize(described_class) }
    
    it "is true if publishing? is true and published_at if blank" do
      object.stub(:publishing?) { true }
      object.stub(:published_at) { nil }
      object.should_set_published_at_to_now?.should be_true
    end
    
    it "is false if publishing? is false and published_at is blank" do
      object.stub(:publishing?) { false }
      object.stub(:published_at) { nil }
      object.should_set_published_at_to_now?.should be_false
    end
    
    it "is false if publishing? is true and published_at is present" do
      object.stub(:publishing?) { true }
      object.stub(:published_at) { Time.now }
      object.should_set_published_at_to_now?.should be_false
    end
    
    it "is false if publishing? is false and published_at is present" do
      object.stub(:publishing?) { false }
      object.stub(:published_at) { Time.now }
      object.should_set_published_at_to_now?.should be_false
    end
  end

  #-----------------
  
  describe "#set_published_at_to_now" do
    let(:object) { build symbolize(described_class), published_at: nil }
    
    context "should_set_published_at_to_now is true" do
      before :each do
        object.stub(:should_set_published_at_to_now?) { true }
      end
      
      it "sets published at to now" do
        time = freeze_time_at(Time.now)
        object.save!
        object.published_at.should eq time
      end
    end
    
    context "should_set_published_at_to_now is false" do
      before :each do
        object.stub(:should_set_published_at_to_now?) { false }
        object.status = ContentBase::STATUS_DRAFT
      end
      
      it "does not set published at to now" do
        time = freeze_time_at(Time.now)
        object.save!
        object.published_at.should be_nil
      end
    end
  end

  #-----------------
  
  describe "#should_set_published_at_to_alarm?" do
    let(:content_alarm) { build :content_alarm }
    let(:object) { build symbolize(described_class) }
    
    it "is true if alarm is present and alarm.fire_at has changed" do
      object.stub(:alarm) { content_alarm }
      object.alarm.stub(:fire_at_changed?) { true }
      object.should_set_published_at_to_alarm?.should be_true
    end

    it "is false if alarm is present and alarm.fire_at has not changed" do
      object.stub(:alarm) { content_alarm }
      object.alarm.stub(:fire_at_changed?) { false }
      object.should_set_published_at_to_alarm?.should be_false
    end

    it "is false if alarm is not present" do
      object.stub(:alarm) { nil }
      object.should_set_published_at_to_alarm?.should be_false
    end
  end
  
  #-----------------
  
  describe "#set_published_at_to_alarm" do
    context "should_set_published_at_to_alarm? is true" do
      let(:object) { build symbolize(described_class), published_at: Chronic.parse("8pm") }
      
      before :each do
        described_class.any_instance.stub(:should_set_published_at_to_alarm?) { true }
        object.build_alarm fire_at: Chronic.parse("4pm")
        object.save!
      end
      
      it "sets published_at to the alarm's fire_at date" do
        object.published_at.should eq Chronic.parse("4pm")
        object.published_at.should_not eq Chronic.parse("8pm")
      end
    end

    context "should_set_published_at_to_alarm? is false" do
      let(:object) { build symbolize(described_class), published_at: Chronic.parse("8pm") }

      before :each do
        described_class.any_instance.stub(:should_set_published_at_to_alarm?) { false }
        object.build_alarm fire_at: Chronic.parse("4pm")
        object.save!
      end
      
      it "does not set published_at to the alarm's fire_at date" do
        object.published_at.should_not eq Chronic.parse("4pm")
        object.published_at.should eq Chronic.parse("8pm")
      end
    end
  end
  
  #-----------------
  
  describe "#should_set_published_at_to_nil?" do
    let(:object) { build symbolize(described_class) }
    
    it "is true if #unpublishing? is true" do
      object.stub(:unpublishing?) { true }
      object.should_set_published_at_to_nil?.should be_true
    end
    
    it "is false if #unpublishing? is false" do
      object.stub(:unpublishing?) { false }
      object.should_set_published_at_to_nil?.should be_false
    end
  end
  
  #-----------------
  
  describe "#set_published_at_to_nil" do
    let(:object) { build symbolize(described_class), published_at: Time.now - 1.hour }
    
    context "should_set_published_at_to_nil? is true" do
      before :each do
        object.stub(:should_set_published_at_to_nil?) { true }
        object.published_at.should_not be_nil
        object.save!
      end
      
      it "sets published_at to nil" do
        object.published_at.should eq nil
      end
    end

    context "should_set_published_at_to_nil? is false" do
      before :each do
        object.stub(:should_set_published_at_to_nil?) { false }
        object.published_at.should_not be_nil
        object.save!
      end
      
      it "does not set published_at to nil" do
        object.published_at.should_not be_nil
      end
    end
  end
end
