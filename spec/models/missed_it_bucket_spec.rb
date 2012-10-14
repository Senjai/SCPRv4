require "spec_helper"

describe MissedItBucket do
  describe "associations" do
    it { should have_many(:contents).class_name("MissedItContent") }
  end
  
  describe "validations" do
    it { should validate_presence_of(:title) }
  end
end
