require 'spec_helper'

describe ContentShell do
  describe "#public_url" do
    it "uses the url attribute" do
      shell = build :content_shell
      shell.public_url.should eq shell.url
    end
  end

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
