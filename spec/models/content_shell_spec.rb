require 'spec_helper'

describe ContentShell do
  describe "#public_url" do
    it "uses the url attribute" do
      shell = build :content_shell
      shell.public_url.should eq shell.url
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
  
  describe "#public_path" do
    it "uses the url attribute" do
      shell = build :content_shell
      shell.public_path.should eq shell.url
    end
  end
  
  describe '#to_article' do
    it 'makes a new article' do
      shell = build :content_shell
      shell.to_article.should be_a Article
    end
  end

  describe '#to_abstract' do
    it 'makes a new abstract' do
      shell = build :content_shell
      shell.to_abstract.should be_a Abstract
    end
  end
end
