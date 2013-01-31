require "spec_helper"

describe Homepage do
  describe "validations" do
    it { should validate_presence_of(:base) }
    it { should ensure_inclusion_of(:base).in_array(Homepage::TEMPLATES.keys) }
  end
  
  #------------------------
  
  describe "#scored_content" do
    pending
  end
end