require 'spec_helper'

describe NewsStory do
  describe "callbacks" do
    it_behaves_like "set published at callback"
  end
  
  # ----------------
  
  describe "validations" do
    it_behaves_like "slug validation"
    it_behaves_like "content validation"
    it_behaves_like "slug unique for date validation" do
      let(:scope) { :published_at }
    end
  end

  #-----------------
  
  describe "associations" do
    it_behaves_like "content alarm association"
    it_behaves_like "asset association"
    it_behaves_like "audio association"
  end
  
  #-----------------
  
  describe "scopes" do
    it_behaves_like "since scope"
    
    describe "#published" do
      it "orders published content by published_at descending" do
        NewsStory.published.to_sql.should match /order by published_at desc/i
      end
    end
  end
  
  #-----------------
  
  describe "#has_format?" do
    it "is false" do
      build(:news_story).has_format?.should be_false
    end
  end
end
