require "spec_helper"

describe KpccProgram do
  describe "associations" do
    it { should have_many :segments }
    it { should have_many :episodes }
    it { should have_many :schedules }
    it { should belong_to :missed_it_bucket }
    it { should belong_to :blog }
  end
  
  describe "#to_param" do
    it "uses the slug" do
      program = build :kpcc_program
      program.to_param.should eq program.slug
    end
  end
  
  describe "twitter_url" do
    it "returns the twitter_url if specified" do
      twitter_url = "airtalk"
      program = build :kpcc_program, twitter_url: twitter_url
      program.twitter_url.should eq twitter_url
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, twitter_url: ""
      program.twitter_url.should eq KpccProgram::ConnectDefaults[:twitter]
    end
  end
  
  describe "facebook_url" do
    it "returns the facebook_url if specified" do
      facebook_url = "facebook.com/airtalk"
      program = build :kpcc_program, facebook_url: facebook_url
      program.facebook_url.should eq facebook_url
    end
    
    it "returns the KPCC fallback if not specified" do
      program = build :kpcc_program, facebook_url: ""
      program.facebook_url.should eq KpccProgram::ConnectDefaults[:facebook]
    end
  end
  
  describe "#twitter_absolute_url" do
    it "returns twitter_url if it's already a url to Twitter" do
      program = build :kpcc_program, twitter_url: "http://twitter.com/kpcc"
      program.twitter_absolute_url.should eq program.twitter_url
    end
    
    it "appends the twitter domain if twitter_url is only a handle" do
      program = build :kpcc_program, twitter_url: "kpcc"
      program.twitter_absolute_url.should eq "http://twitter.com/#{program.twitter_url}"
    end
  end
end