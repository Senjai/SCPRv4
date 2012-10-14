require "spec_helper"

describe FeaturedCommentBucket do
  describe "associations" do
    it { should have_many(:comments).class_name("FeaturedComment") }
  end
  
  describe "validations" do
    it { should validate_presence_of(:title) }
  end
end
