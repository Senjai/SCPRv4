require "spec_helper"

describe ApplicationController do
<<<<<<< HEAD
  pending
=======
  describe "verify_natural" do
    it "returns page if it's a natural number > 0" do
      controller.verify_natural(50).should eq 50
    end
    
    it "returns 1 if it's not a number" do
      controller.verify_natural("no").should eq 1
    end
    
    it "returns 1 if it's less than 1" do
      controller.verify_natural(-5).should eq 1
    end
  end
>>>>>>> origin/master
end
