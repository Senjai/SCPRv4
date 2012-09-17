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
    it "is true" do
      build(:news_story).has_format?.should be_false
    end
  end

  # ----------------
  
  describe "#auto_published_at" do
    it "is true" do
      create(:news_story).auto_published_at.should be_true
    end
  end

  #-----------------
  
  describe "#link_path" do
    it "does not override the hard-coded options" do
      news_story = create :news_story
      news_story.link_path(slug: "wrong").should_not match "wrong"
    end
  end
end
