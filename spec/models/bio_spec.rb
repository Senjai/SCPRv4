require "spec_helper"

describe Bio do  
  describe "callbacks" do
    describe "set_last_name" do
      it "sets last name if last name isn't present" do
        bio = create :bio, name: "Bryan Ricker", last_name: nil
        bio.last_name.should eq "Ricker"
      end
      
      it "doesn't set last name if last_name is present" do
        bio = create :bio, name: "Bryan Ricker", last_name: "Dudebro"
        bio.last_name.should eq "Dudebro"
      end
    end
  end
  
  #--------------------
  
  describe "twitter_url" do
    it "returns a twitter URL if twitter handle is present" do
      bio = create :bio, twitter: "@larrymantle"
      bio.twitter_url.should match /twitter\.com/
    end
    
    it "subs out the @" do
      bio = create :bio, twitter: "@larrymantle"
      bio.twitter_url.should_not match /@/
    end
    
    it "returns nil if twitter handle is not present" do
      bio = create :bio, twitter: ""
      bio.twitter_url.should be_nil
    end
  end

  #--------------------
  
  describe "indexed_bylines" do
    describe "max_results checking" do
      let(:bio) { create :bio }
      
      it "typecasts page and per_page to integers" do
        # TypeError, ArgumentError, or NoMethodError possible here... 
        # we'll just test for *any* error.
        -> { bio.indexed_bylines("1", 9999) }.should_not raise_error
        -> { bio.indexed_bylines("1", "9999") }.should_not raise_error
      end
        
      it "uses Sphinx if page number will not cause offset error" do
        ContentByline.should_receive(:search)
        bio.should_not_receive(:content)
        bio.indexed_bylines(1)
      end
  
      it "returns an array using sphinx" do
        bio.indexed_bylines(1).should be_a Array
      end
      
      it "doesn't raise error if offset is exceeded" do
        -> { bio.indexed_bylines(9999) }.should_not raise_error
      end
    
      it "fallsback to SQL if offset will exceed SPHINX_MAX_MATCHES" do
        ContentByline.should_not_receive(:search)
        content = create(:news_story)
        byline = create :byline, user: bio, content: content
        bio.indexed_bylines(1, 9999).should eq [byline] 
      end
      
      it "returns an array using SQL even if no records found" do
        bio.indexed_bylines(1, 9999).should be_a Array
      end
    end

    #--------------------
    
    describe "mysql method" do
      let(:bio) { create :bio }
  
      it "only returns published content" do
        unpub        = create :news_story, status: 4
        pub          = create :news_story, status: 5
        byline_pub   = create :content_byline, user: bio, content: pub
        byline_unpub = create :content_byline, user: bio, content: unpub
        bio.indexed_bylines(1, 9999).should eq [byline_pub]
      end
      
      it "sorts by published_at desc" do
        news_older   = create :news_story, published_at: Chronic.parse("3 days ago") 
        news_newer   = create :news_story, published_at: Chronic.parse("2 days ago")
        byline_older = create :content_byline, user: bio, content: news_older
        byline_newer = create :content_byline, user: bio, content: news_newer
        bio.indexed_bylines(1, 9999).first.should eq byline_newer
      end
    end
  end

  #--------------------
  
  describe "headshot" do
    it "returns the asset if asset_id is set" do
      bio = create :bio, asset_id: 999
      bio.headshot.should be_a AssetHost::Asset
    end
    
    it "returns false if asset_id isn't set" do
      bio = create :bio, asset_id: nil
      bio.headshot.should be_false
    end
  end
end
