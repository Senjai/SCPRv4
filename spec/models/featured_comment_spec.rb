require "spec_helper"

describe FeaturedComment do
  describe "associations" do
    it_behaves_like "content alarm association"
    it { should belong_to(:content) }
    it { should belong_to(:bucket).class_name("FeaturedCommentBucket") }
  end

  #-------------------
  
  describe "callbacks" do
    it_behaves_like "set published at callback"
  end
  
  #-------------------
  
  describe "validations" do    
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:status) }
    
    context "should validate" do
      subject { create :featured_comment, :published }
      it { should validate_presence_of(:excerpt) }
      it { should validate_presence_of(:bucket_id) }
      it { should validate_presence_of(:content_id) }
      it { should validate_presence_of(:content_type) }
    end
    
    context "should not validate" do
      subject { create :featured_comment, :draft }
      it { should_not validate_presence_of(:excerpt) }
      it { should_not validate_presence_of(:bucket_id) }
      it { should_not validate_presence_of(:content_id) }
      it { should_not validate_presence_of(:content_type) }
    end
  end

  it_behaves_like "status methods"
  it_behaves_like "publishing methods"
end
