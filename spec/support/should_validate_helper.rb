##
# ShouldValidateHelpers
# Helper blocks to test validation conditions
#
module ShouldValidateHelpers
  def should_validate
    context "should validate" do      
      before :each do
        described_class.any_instance.stub(:should_validate?) { true }
      end
      
      it "stubs should_validate? to true" do
        described_class.new.should_validate?.should eq true
      end
      
      yield
    end
  end
  
  #------------
  
  def should_not_validate
    context "should not validate" do
      before :each do
        described_class.any_instance.stub(:should_validate?) { false }
      end
      
      it "stubs should_validate? to false" do
        puts described_class.new.should_validate?
        described_class.new.should_validate?.should eq false
      end
      
      yield
    end
  end
end
