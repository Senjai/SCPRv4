require "spec_helper"

describe ProgramPresenter do  
  describe "#teaser" do
    it "returns html_safe teaser if it's present" do
      program = build :kpcc_program, teaser: "This is <b>cool</b> teaser, bro."
      p = presenter(program)
      p.teaser.should eq "This is <b>cool</b> teaser, bro."
      p.teaser.html_safe?.should be_true
    end
    
    it "returns nil if teaser not present" do
      program = build :kpcc_program, teaser: nil
      p = presenter(program)
      p.teaser.should eq nil
    end
  end
  
  #--------------------
  
  describe "#description" do
    it "returns html_safe description if it's present" do
      program = build :kpcc_program, description: "This is <b>cool</b> description, bro."
      p = presenter(program)
      p.description.should eq "This is <b>cool</b> description, bro."
      p.description.html_safe?.should be_true
    end
    
    it "returns nil if description not present" do
      program = build :kpcc_program, description: nil
      p = presenter(program)
      p.description.should eq nil
    end
  end
  
  #--------------------
  
  describe "feed" do
    it "returns podcast cache if it's present" do
      program = build :other_program, slug: "coolshow"
      Rails.cache.write("ext_program:coolshow:podcast", "Cool Show Podcast!")
      p = presenter(program)
      p.feed.should match "Cool Show Podcast!"
    end
    
    it "returns rss cache if it's present" do
      program = build :other_program, slug: "coolshow"
      Rails.cache.write("ext_program:coolshow:rss", "Cool Show RSS!")
      p = presenter(program)
      p.feed.should match "Cool Show RSS!"
    end
    
    it "returns a message if no cache is availabe" do
      program = build :other_program
      p = presenter(program)
      p.feed.should match "none-to-list"
    end
  end
  
  #--------------------
  
  describe "#web_url" do
    it "returns program.web_url if specified" do
      program = build :other_program, web_url: "show.com/coolshow"
      p = presenter(program)
      p.web_url.should eq "show.com/coolshow"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :other_program, web_url: ""
      p = presenter(program)
      p.web_url.should eq CONNECT_DEFAULTS[:web]
    end
  end
  
  #--------------------
  
  describe "#twitter_url" do    
    it "returns program.twitter_url as-is if specified and is already a full URL to twitter" do
      program = build :kpcc_program, twitter_url: "http://twitter.com/airtalk"
      p = presenter(program)
      p.twitter_url.should eq "http://twitter.com/airtalk"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, twitter_url: ""
      p = presenter(program)
      p.twitter_url.should eq CONNECT_DEFAULTS[:twitter]
    end
    
    it "appends the twitter domain if program.twitter_url is only a handle" do
      program = build :kpcc_program, twitter_url: "kpcc"
      p = presenter(program)
      p.twitter_url.should eq "http://twitter.com/kpcc"
    end
  end

  #--------------------
  
  describe "#facebook_url" do
    it "returns the program.facebook_url if specified" do
      program = build :kpcc_program, facebook_url: "facebook.com/airtalk"
      p = presenter(program)
      p.facebook_url.should eq "facebook.com/airtalk"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, facebook_url: ""
      p = presenter(program)
      p.facebook_url.should eq CONNECT_DEFAULTS[:facebook]
    end
  end
  
  #--------------------
  
  describe "#rss_url" do
    it "returns program.rss_url if specified" do
      program = build :kpcc_program, rss_url: "show.com/coolshow.xml"
      p = presenter(program)
      p.rss_url.should eq "show.com/coolshow.xml"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, rss_url: ""
      p = presenter(program)
      p.rss_url.should eq CONNECT_DEFAULTS[:rss]
    end
  end
  
  #--------------------
  
  describe "#podcast_url" do
    it "returns program.podcast_url if specified" do
      program = build :kpcc_program, podcast_url: "cool-podcast/bro.xml"
      p = presenter(program)
      p.podcast_url.should eq "cool-podcast/bro.xml"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, podcast_url: ""
      p = presenter(program)
      p.podcast_url.should eq CONNECT_DEFAULTS[:podcast]
    end
  end

  #--------------------
end
