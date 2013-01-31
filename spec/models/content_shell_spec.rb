require 'spec_helper'

describe ContentShell do
  describe "#remote_link_path" do
    it "uses the url attribute" do
      shell = build :content_shell
      shell.remote_link_path.should eq shell.url
    end
  end
  
  #-----------------
  
  describe "comments" do
    it "doesn't respond to disqus_identifier" do
      build(:content_shell).should_not respond_to :disqus_identifier
    end
  end
  
  #--------------------

  describe "#body" do
    it "is the teaser" do
      content_shell = build :content_shell
      content_shell.body.should eq content_shell.teaser
    end
  end
  
  #-----------------
  
  describe "#link_path" do
    it "uses the url attribute" do
      shell = build :content_shell
      shell.link_path.should eq shell.url
    end
  end
  
  #-----------------
end
