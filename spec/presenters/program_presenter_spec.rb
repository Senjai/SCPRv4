require "spec_helper"

describe ProgramPresenter do
  describe "#twitter_url" do    
    it "returns program.twitter_url as-is if specified and is already a full URL to twitter" do
      program = build :kpcc_program, twitter_url: "http://twitter.com/airtalk"
      p = ProgramPresenter.new(program, view)
      p.twitter_url.should eq "http://twitter.com/airtalk"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, twitter_url: ""
      p = ProgramPresenter.new(program, view)
      p.twitter_url.should eq CONNECT_DEFAULTS[:twitter]
    end
    
    it "appends the twitter domain if program.twitter_url is only a handle" do
      program = build :kpcc_program, twitter_url: "kpcc"
      p = ProgramPresenter.new(program, view)
      p.twitter_url.should eq "http://twitter.com/kpcc"
    end
  end

  #--------------------
  
  describe "#facebook_url" do
    it "returns the program.facebook_url if specified" do
      program = build :kpcc_program, facebook_url: "facebook.com/airtalk"
      p = ProgramPresenter.new(program, view)
      p.facebook_url.should eq "facebook.com/airtalk"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, facebook_url: ""
      p = ProgramPresenter.new(program, view)
      p.facebook_url.should eq CONNECT_DEFAULTS[:facebook]
    end
  end
  
  #--------------------
  
  describe "#rss_url" do
    it "returns program.rss_url if specified" do
      program = build :kpcc_program, rss_url: "show.com/coolshow.xml"
      p = ProgramPresenter.new(program, view)
      p.rss_url.should eq "show.com/coolshow.xml"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, rss_url: ""
      p = ProgramPresenter.new(program, view)
      p.rss_url.should eq CONNECT_DEFAULTS[:rss]
    end
  end
  
  #--------------------
  
  describe "#podcast_url" do
    it "returns program.podcast_url if specified" do
      program = build :kpcc_program, podcast_url: "cool-podcast/bro.xml"
      p = ProgramPresenter.new(program, view)
      p.podcast_url.should eq "cool-podcast/bro.xml"
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, podcast_url: ""
      p = ProgramPresenter.new(program, view)
      p.podcast_url.should eq CONNECT_DEFAULTS[:podcast]
    end
  end

  #--------------------

  describe "#teaser" do
    it "returns html_safe teaser if it's present" do
      program = build :kpcc_program, teaser: "This is <b>cool</b> teaser, bro."
      p = ProgramPresenter.new(program, view)
      p.teaser.should eq "This is <b>cool</b> teaser, bro."
      p.teaser.html_safe?.should be_true
    end
    
    it "returns nil if teaser not present" do
      program = build :kpcc_program, teaser: nil
      p = ProgramPresenter.new(program, view)
      p.teaser.should eq nil
    end
  end
end
