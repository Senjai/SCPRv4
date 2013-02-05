require "spec_helper"

describe Flatpage do
  describe "validations" do
    it "validates uniqueness" do
      create :flatpage
      should validate_uniqueness_of(:url)
    end
    
    it("validates presence") { should validate_presence_of(:url) }
  end

  #--------------------
  
  describe "scopes" do
    describe "visible" do
      it "only selects flatpages with is_public true" do
        is_public  = create :flatpage, is_public: true
        not_public = create :flatpage, is_public: false
        Flatpage.visible.should eq [is_public]
      end
    end
  end
  
  #--------------------
  
  describe "url" do
    it "appends a slash if there isn't one" do
      flatpage = build :flatpage, url: "hello"
      flatpage.url.should match /\//
    end
  end

  #--------------------
  
  describe "path" do
    it "strips leading and trailing slashes" do
      flatpage = build :flatpage, url: "/about/people/"
      flatpage.path.should eq "about/people"
    end
  end

  #--------------------
    
  describe "downcase_url" do
    it "runs before validation" do
      flatpage = build :flatpage, url: "/HELLO/"
      flatpage.save
      flatpage.url.should_not match /HELLO/
      flatpage.url.should match /hello/
    end
  end

  #--------------------
  
  describe "slashify" do
    it "runs before validations" do
      flatpage = build :flatpage, url: "hello"
      flatpage.save
      flatpage.url.should eq "/hello/"
      flatpage.should be_valid
    end
    
    it "adds slashes to the beginning and end of url if it needs it" do
      flatpage = build :flatpage, url: "hello"
      flatpage.slashify
      flatpage.url.should eq "/hello/"
    end
    
    it "leaves the url alone if it already has slashes" do
      flatpage = build :flatpage, url: "/hello/"
      flatpage.slashify
      flatpage.url.should eq "/hello/"
    end
    
    it "adds a slash to the beginning if one doesn't exist" do
      flatpage = build :flatpage, url: "hello/"
      flatpage.slashify
      flatpage.url.should eq "/hello/"
    end
    
    it "adds a slash to the end if one doesn't exist" do
      flatpage = build :flatpage, url: "/hello"
      flatpage.slashify
      flatpage.url.should eq "/hello/"
    end
    
    it "leaves slashes in the middle alone" do
      flatpage = build :flatpage, url: "hello/whats/up"
      flatpage.slashify
      flatpage.url.should eq "/hello/whats/up/"
    end
  end

  #--------------------

  describe '#is_redirect?' do
    it "is true if redirect_url is present" do
      flatpage = build :flatpage, redirect_url: "/bros/"
      flatpage.is_redirect?.should eq true
    end

    it "is false if redirect_url is blank" do
      flatpage = build :flatpage, redirect_url: ""
      flatpage.is_redirect?.should eq false
    end
  end
end
