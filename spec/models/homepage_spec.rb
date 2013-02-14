require "spec_helper"

describe Homepage do
  describe "validations" do
    it { should validate_presence_of(:base) }
  end
  
  #------------------------
  
  describe "#scored_content" do
    pending
  end
end
