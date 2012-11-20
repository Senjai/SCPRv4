require "spec_helper"

describe Homepage do
  describe "associations" do
    it_behaves_like "content alarm association"
    
    it { should belong_to(:missed_it_bucket) }
    it { should have_many(:content).class_name("HomepageContent") }
  end

  #------------------
   
  describe "validations" do
    it { should validate_presence_of(:base) }
    it { should ensure_inclusion_of(:base).in_array(Homepage::TEMPLATES.keys) }
  end

  #------------------
  
  describe "callbacks" do
    it_behaves_like "set published at callback"
  end
  
  #------------------

  it_behaves_like "status methods"
  it_behaves_like "publishing methods"

  #------------------
  
  describe "#scored_content" do
    pending
  end
end