require 'spec_helper'

describe UrlValidator do
  describe "default" do
    it "requires a protocol" do
      story = build :test_class_remote_story, remote_url: "www.whatever.com"
      story.should_not be_valid
      story.errors.keys.should include :remote_url
    end

    it "allows URIs with HTTP protocol" do
      story = build :test_class_remote_story, remote_url: "http://www.whatever.com"
      story.should be_valid
    end

    it "allows HTTPS protocol (because it inherits from URI::HTTP)" do
      story = build :test_class_remote_story, remote_url: "https://www.whatever.com"
      story.should be_valid
    end

    it "doesn't allow FTP protocol" do
      story = build :test_class_remote_story, remote_url: "ftp://www.whatever.com"
      story.should_not be_valid
      story.errors.keys.should include :remote_url
    end
  end

  #-----------------

  it "handles a URI Error gracefully" do
    story = build :test_class_remote_story, remote_url: '######'
    story.should_not be_valid
    story.errors.keys.should include :remote_url
  end

  it "allows FTP protocol if passed in" do
    story = build :test_class_story, short_url: "ftp://www.whatever.com"
    story.should be_valid
  end

  it "encodes the URI" do
    bad_uri = "http://www.freep.com/article/20120615/BLOG36/120615034/vagina-Michigan-House-Representatives-Lisa-Brown-Barb-Byrum-abortion?odyssey=tab|topnews|text|FRONTPAGE"
    story = build :test_class_story, short_url: bad_uri
    story.should be_valid
  end

  it "accepts an alternate message" do
    person = build :test_class_person, twitter_url: '#####'
    person.should_not be_valid
    person.errors.messages[:twitter_url].should eq ["bad url"]
  end

  it "allows blank if specified" do
    person = build :test_class_person, twitter_url: nil
    person.should be_valid
  end
end
