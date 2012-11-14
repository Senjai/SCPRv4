##
# Shared Methods Specs
# Concern::Methods
#

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

#--------------------

shared_examples_for "status methods" do
  it { should respond_to :published? }
  it { should respond_to :pending? }
  it { should respond_to :awaiting_rework? }
  it { should respond_to :awaiting_edits? }
  it { should respond_to :draft? }
  it { should respond_to :killed? }
end

#--------------------

shared_examples_for "publishing methods" do
  describe "shared publishing methods" do
    let(:object) { create symbolize(described_class) }
  
    describe "#publishing?" do
      it "is true if status was changed to published" do
        object.stub(:status_changed?) { true }
        object.stub(:published?) { true }
        object.publishing?.should eq true
      end
    
      it "is false if status was changed to not published" do
        object.stub(:status_changed?) { true }
        object.stub(:published?) { false }        
        object.publishing?.should eq false
      end
    
      it "is false if status was not changed, and object is published" do
        object.stub(:status_changed?) { false }
        object.stub(:published?) { true }
        object.publishing?.should eq false
      end
    
      it "is false if status was not changed, and object is not published" do
        object.stub(:status_changed?) { false }
        object.stub(:published?) { false }
        object.publishing?.should eq false
      end
    end
  
    #--------------------
    
    describe "#unpublishing?" do
      it "is true of status was changed and status was STATUS_LIVE" do
        object.stub(:status_changed?) { true }
        object.stub(:status_was) { ContentBase::STATUS_LIVE }
        object.unpublishing?.should eq true
      end
      
      it "returns false if status was not changed" do
        object.stub(:status_changed?) { false }
        object.unpublishing?.should be false
      end
      
      it "returns false if status was changed but was not live" do
        object.stub(:status_changed?) { true }
        object.stub(:status_was) { ContentBase::STATUS_DRAFT }
        object.unpublishing?.should eq false
      end
      
      it "returns false if status was not changed and status is status_live" do
        object.stub(:status_changed?) { false }
        object.stub(:status_was) { ContentBase::STATUS_LIVE }
        object.unpublishing?.should eq false
      end
    end
  end
end
