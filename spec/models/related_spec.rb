require "spec_helper"

describe Related do
  it { should belong_to(:related) }
  it { should belong_to(:content) }
  
  describe "scopes" do
    before :all do
      content = create :news_story
      related = create :blog_entry
      @tiein = create :frel, content: content, related: related, flag: Related::FLAG_TIEIN
      @update = create :frel, content: content, related: related, flag: Related::FLAG_UPDATE
      @normal = create :frel, content: content, related: related, flag: Related::FLAG_NORMAL
    end
    
    it "tiein only returns related with tiein flag" do
      tieins = Related.tiein
      tieins.count.should eq 1
      tieins.first.should eq @tiein    
    end
  
    it "updates only returns related with update flag" do
      updates = Related.updates
      updates.count.should eq 1
      updates.first.should eq @update
    end
  
    it "normal only returns related with normal flag" do
      normals = Related.normal
      normals.count.should eq 1
      normals.first.should eq @normal
    end
  
    it "notieindoes not return related with tiein flag" do
      notieins = Related.notiein
      notieins.include?(@tiein).should be_false
      notieins.include?(@update).should be_true
      notieins.include?(@normal).should be_true
    end
  end
  
  describe "sorted" do
    it "sorts by the content's public_datetime" do
      pending
    end
  end
end